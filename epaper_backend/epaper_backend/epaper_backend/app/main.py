from fastapi import FastAPI, Request, Depends
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session
from sqlalchemy import text
from fastapi import Form, HTTPException, status

from .database import Base, engine, get_db
from .routers import products, displays
from . import models

Base.metadata.create_all(bind=engine)

app = FastAPI(title="E-Paper Price Display API")

# Templates
templates = Jinja2Templates(directory="app/templates")


@app.get("/")
def read_root():
    return {"message": "API is running"}


# Gắn routers API JSON
app.include_router(products.router)
app.include_router(displays.router)


# --------------------------
# ADMIN: Products
# --------------------------

@app.get("/admin/products", response_class=HTMLResponse)
def admin_products_list(request: Request, db: Session = Depends(get_db)):
    items = db.query(models.Product).all()
    return templates.TemplateResponse(
        "products_list.html",
        {"request": request, "products": items}
    )


@app.get("/admin/products/new", response_class=HTMLResponse)
def admin_product_new_form(request: Request):
    class Empty:
        pass
    empty = Empty()
    empty.id = None
    empty.sku = ""
    empty.name = ""
    empty.price = ""
    empty.currency = "VND"
    empty.description = ""
    empty.image_url = ""
    empty.status = "active"

    return templates.TemplateResponse(
        "product_form.html",
        {
            "request": request,
            "form_title": "Thêm sản phẩm",
            "product": empty,
            "is_edit": False,
        },
    )


@app.post("/admin/products/new")
def admin_product_create(
    request: Request,
    sku: str = Form(...),
    name: str = Form(...),
    price: float = Form(...),
    currency: str = Form("VND"),
    description: str = Form(""),
    image_url: str = Form(""),
    status_value: str = Form("active"),
    db: Session = Depends(get_db),
):
    if db.query(models.Product).filter_by(sku=sku).first():
        raise HTTPException(status_code=400, detail="SKU already exists")

    product = models.Product(
        sku=sku,
        name=name,
        price=price,
        currency=currency,
        description=description or None,
        image_url=image_url or None,
        status=status_value,
    )
    db.add(product)
    db.commit()
    return RedirectResponse(url="/admin/products", status_code=status.HTTP_303_SEE_OTHER)


# ====== EDIT PRODUCT ======

@app.get("/admin/products/{product_id}/edit", response_class=HTMLResponse)
def admin_product_edit_form(
    request: Request,
    product_id: int,
    db: Session = Depends(get_db),
):
    product = db.query(models.Product).get(product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    return templates.TemplateResponse(
        "product_form.html",
        {
            "request": request,
            "form_title": "Sửa sản phẩm",
            "product": product,
            "is_edit": True,
        },
    )


@app.post("/admin/products/{product_id}/edit")
def admin_product_update(
    request: Request,
    product_id: int,
    name: str = Form(...),
    price: float = Form(...),
    currency: str = Form("VND"),
    description: str = Form(""),
    image_url: str = Form(""),
    status_value: str = Form("active"),
    db: Session = Depends(get_db),
):
    product = db.query(models.Product).get(product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    product.name = name
    product.price = price
    product.currency = currency
    product.description = description or None
    product.image_url = image_url or None
    product.status = status_value

    db.commit()
    return RedirectResponse(url="/admin/products", status_code=status.HTTP_303_SEE_OTHER)


# ====== DELETE PRODUCT ======

@app.post("/admin/products/{product_id}/delete")
def admin_product_delete(product_id: int, db: Session = Depends(get_db)):
    product = db.query(models.Product).get(product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    db.delete(product)
    db.commit()
    return RedirectResponse(url="/admin/products", status_code=status.HTTP_303_SEE_OTHER)

# --------------------------
# ADMIN: Displays
# --------------------------

@app.get("/admin/displays", response_class=HTMLResponse)
def admin_displays_list(request: Request, db: Session = Depends(get_db)):
    displays = db.query(models.Display).all()

    row = db.execute(
        text("SELECT value FROM settings WHERE `key`='active_display_code' LIMIT 1")
    ).first()
    active_code = row[0] if row else ""

    return templates.TemplateResponse(
        "displays_list.html",
        {"request": request, "displays": displays, "active_code": active_code}
    )
@app.post("/admin/displays/active")
def admin_set_active_display(
    active_code: str = Form(...),
    db: Session = Depends(get_db),
):
    # MySQL 8+ syntax (không warning VALUES())
    db.execute(
        text("""
            INSERT INTO settings(`key`, `value`)
            VALUES ('active_display_code', :v) AS new
            ON DUPLICATE KEY UPDATE value = new.value
        """),
        {"v": active_code},
    )
    db.commit()
    return RedirectResponse(url="/admin/displays", status_code=status.HTTP_303_SEE_OTHER)



@app.get("/admin/displays/new", response_class=HTMLResponse)
def admin_display_new_form(request: Request, db: Session = Depends(get_db)):
    products = db.query(models.Product).all()

    class Empty:
        pass
    d = Empty()
    d.id = None
    d.code = ""
    d.name = ""
    d.location = ""
    d.product_id = None

    return templates.TemplateResponse(
        "display_form.html",
        {
            "request": request,
            "form_title": "Thêm display",
            "display": d,
            "products": products,
            "is_edit": False,
        },
    )


@app.post("/admin/displays/new")
def admin_display_create(
    request: Request,
    code: str = Form(...),
    name: str = Form(""),
    location: str = Form(""),
    product_id: str = Form(""),
    db: Session = Depends(get_db),
):
    if db.query(models.Display).filter_by(code=code).first():
        raise HTTPException(status_code=400, detail="Display code already exists")

    pid = int(product_id) if product_id else None

    display = models.Display(
        code=code,
        name=name or None,
        location=location or None,
        product_id=pid,
    )
    db.add(display)
    db.commit()
    return RedirectResponse(url="/admin/displays", status_code=status.HTTP_303_SEE_OTHER)


@app.get("/admin/displays/{display_id}/edit", response_class=HTMLResponse)
def admin_display_edit_form(
    request: Request,
    display_id: int,
    db: Session = Depends(get_db),
):
    display = db.query(models.Display).get(display_id)
    if not display:
        raise HTTPException(status_code=404, detail="Display not found")

    products = db.query(models.Product).all()

    return templates.TemplateResponse(
        "display_form.html",
        {
            "request": request,
            "form_title": "Sửa display",
            "display": display,
            "products": products,
            "is_edit": True,
        },
    )


@app.post("/admin/displays/{display_id}/edit")
def admin_display_update(
    request: Request,
    display_id: int,
    name: str = Form(""),
    location: str = Form(""),
    product_id: str = Form(""),
    db: Session = Depends(get_db),
):
    display = db.query(models.Display).get(display_id)
    if not display:
        raise HTTPException(status_code=404, detail="Display not found")

    pid = int(product_id) if product_id else None

    display.name = name or None
    display.location = location or None
    display.product_id = pid

    db.commit()
    return RedirectResponse(url="/admin/displays", status_code=status.HTTP_303_SEE_OTHER)


@app.post("/admin/displays/{display_id}/delete")
def admin_display_delete(display_id: int, db: Session = Depends(get_db)):
    display = db.query(models.Display).get(display_id)
    if not display:
        raise HTTPException(status_code=404, detail="Display not found")

    db.delete(display)  # log trạng thái sẽ bị xoá theo FK CASCADE
    db.commit()
    return RedirectResponse(url="/admin/displays", status_code=status.HTTP_303_SEE_OTHER)
