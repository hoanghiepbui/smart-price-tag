# app/routers/displays.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import text

from datetime import datetime
from typing import List

from ..database import get_db
from .. import models, schemas

router = APIRouter(prefix="/display", tags=["displays"])

def get_active_display_code(db: Session) -> str:
    row = db.execute(
        text("SELECT value FROM settings WHERE `key` = :k LIMIT 1"),
        {"k": "active_display_code"},
    ).first()
    if not row or not row[0]:
        raise HTTPException(status_code=404, detail="Active display is not set")
    return str(row[0])

# ------------------------
# CRUD cơ bản cho Display
# (dùng cho backend admin/web)
# ------------------------

@router.post("/", response_model=schemas.DisplayOut, status_code=status.HTTP_201_CREATED)
def create_display(display_in: schemas.DisplayCreate, db: Session = Depends(get_db)):
    # check trùng code
    if db.query(models.Display).filter_by(code=display_in.code).first():
        raise HTTPException(status_code=400, detail="Display code already exists")

    display = models.Display(**display_in.dict())
    db.add(display)
    db.commit()
    db.refresh(display)
    return display


@router.get("/", response_model=List[schemas.DisplayOut])
def list_displays(skip: int = 0, limit: int = 50, db: Session = Depends(get_db)):
    return db.query(models.Display).offset(skip).limit(limit).all()


@router.get("/id/{display_id}", response_model=schemas.DisplayOut)
def get_display_by_id(display_id: int, db: Session = Depends(get_db)):
    display = db.query(models.Display).get(display_id)
    if not display:
        raise HTTPException(status_code=404, detail="Display not found")
    return display


@router.put("/id/{display_id}", response_model=schemas.DisplayOut)
def update_display_by_id(
    display_id: int,
    display_in: schemas.DisplayUpdate,
    db: Session = Depends(get_db),
):
    display = db.query(models.Display).get(display_id)
    if not display:
        raise HTTPException(status_code=404, detail="Display not found")

    for field, value in display_in.dict(exclude_unset=True).items():
        setattr(display, field, value)

    db.commit()
    db.refresh(display)
    return display


@router.delete("/id/{display_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_display(display_id: int, db: Session = Depends(get_db)):
    display = db.query(models.Display).get(display_id)
    if not display:
        raise HTTPException(status_code=404, detail="Display not found")

    db.delete(display)
    db.commit()
    return

# ------------------------
# Active Display (admin chọn 1 display "đang active")
# ESP32 có thể gọi /display/active thay vì cố định DISPLAY_CODE trong firmware
# ------------------------

@router.get("/active", response_model=schemas.DisplayProductPayload)
def get_active_display_payload(db: Session = Depends(get_db)):
    code = get_active_display_code(db)
    display = db.query(models.Display).filter_by(code=code).first()
    if not display:
        raise HTTPException(status_code=404, detail="Active display not found")

    product = display.product
    return schemas.DisplayProductPayload(
        code=display.code,
        product_sku=product.sku if product else None,
        product_name=product.name if product else None,
        price=float(product.price) if product else None,
        currency=product.currency if product else None,
        description=product.description if product else None,
        image_url=product.image_url if product else None,
        updated_at=product.updated_at if product else None,
    )


@router.get("/active/status", response_model=schemas.DisplayOut)
def get_active_display_status(db: Session = Depends(get_db)):
    code = get_active_display_code(db)
    display = db.query(models.Display).filter_by(code=code).first()
    if not display:
        raise HTTPException(status_code=404, detail="Active display not found")
    return display


@router.put("/active/status", response_model=schemas.DisplayOut)
def update_active_display_status(
    status_in: schemas.DisplayStatusUpdate,
    db: Session = Depends(get_db),
):
    code = get_active_display_code(db)
    display = db.query(models.Display).filter_by(code=code).first()
    if not display:
        raise HTTPException(status_code=404, detail="Active display not found")

    data = status_in.dict(exclude_unset=True)
    for field, value in data.items():
        setattr(display, field, value)

    display.last_seen_at = datetime.utcnow()

    log = models.DisplayStatusLog(
        display_id=display.id,
        battery_level=status_in.battery_level,
        signal_strength=status_in.signal_strength,
        status=status_in.status,
        firmware_version=status_in.firmware_version,
    )
    db.add(log)

    db.commit()
    db.refresh(display)
    return display

# ------------------------
# Task 5: GET /display/{code}
# ESP32 dùng endpoint này để lấy dữ liệu hiển thị
# ------------------------

@router.get("/{code}", response_model=schemas.DisplayProductPayload)
def get_display_payload(code: str, db: Session = Depends(get_db)):
    """
    ESP32 gọi endpoint này để lấy thông tin sản phẩm cần hiển thị.
    """
    display = db.query(models.Display).filter_by(code=code).first()
    if not display:
        raise HTTPException(status_code=404, detail="Display not found")

    product = display.product  # relationship từ models.Display → Product

    # Nếu chưa gán product_id thì vẫn trả payload nhưng product_* = null
    return schemas.DisplayProductPayload(
        code=display.code,
        product_sku=product.sku if product else None,
        product_name=product.name if product else None,
        price=float(product.price) if product else None,
        currency=product.currency if product else None,
        description=product.description if product else None,
        image_url=product.image_url if product else None,
        updated_at=product.updated_at if product else None,
    )


# ------------------------
# Task 6: /display/{code}/status
# GET: xem trạng thái hiện tại
# PUT: ESP32 gửi trạng thái mới
# ------------------------

@router.get("/{code}/status", response_model=schemas.DisplayOut)
def get_display_status(code: str, db: Session = Depends(get_db)):
    """
    Dashboard / backend gọi để xem tình trạng hiện tại của 1 display.
    """
    display = db.query(models.Display).filter_by(code=code).first()
    if not display:
        raise HTTPException(status_code=404, detail="Display not found")
    return display


@router.put("/{code}/status", response_model=schemas.DisplayOut)
def update_display_status(
    code: str,
    status_in: schemas.DisplayStatusUpdate,
    db: Session = Depends(get_db),
):
    """
    ESP32 gửi trạng thái: pin, RSSI, status, firmware.
    """
    display = db.query(models.Display).filter_by(code=code).first()
    if not display:
        raise HTTPException(status_code=404, detail="Display not found")

    # cập nhật trường trạng thái trên bảng displays
    data = status_in.dict(exclude_unset=True)
    for field, value in data.items():
        setattr(display, field, value)

    display.last_seen_at = datetime.utcnow()

    # tạo log (nếu bạn muốn lưu lịch sử)
    log = models.DisplayStatusLog(
        display_id=display.id,
        battery_level=status_in.battery_level,
        signal_strength=status_in.signal_strength,
        status=status_in.status,
        firmware_version=status_in.firmware_version,
    )
    db.add(log)

    db.commit()
    db.refresh(display)
    return display
