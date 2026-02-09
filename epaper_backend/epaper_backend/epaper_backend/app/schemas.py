# app/schemas.py
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

# ------------------------
# Product Schemas
# ------------------------

class ProductBase(BaseModel):
    sku: str
    name: str
    price: float
    currency: str = "VND"
    description: Optional[str] = None
    image_url: Optional[str] = None
    status: str = "active"


class ProductCreate(ProductBase):
    pass


class ProductUpdate(BaseModel):
    name: Optional[str] = None
    price: Optional[float] = None
    currency: Optional[str] = None
    description: Optional[str] = None
    image_url: Optional[str] = None
    status: Optional[str] = None


class ProductOut(ProductBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True


# ------------------------
# Display Schemas
# ------------------------

class DisplayBase(BaseModel):
    code: str
    name: Optional[str] = None
    location: Optional[str] = None
    product_id: Optional[int] = None


class DisplayCreate(DisplayBase):
    pass


class DisplayUpdate(BaseModel):
    name: Optional[str] = None
    location: Optional[str] = None
    product_id: Optional[int] = None
    status: Optional[str] = None


class DisplayStatusUpdate(BaseModel):
    battery_level: Optional[int] = None
    signal_strength: Optional[int] = None
    status: Optional[str] = None
    firmware_version: Optional[str] = None


class DisplayOut(DisplayBase):
    id: int
    battery_level: Optional[int] = None
    signal_strength: Optional[int] = None
    last_seen_at: Optional[datetime] = None
    status: str
    firmware_version: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True


# Payload trả cho ESP32 khi gọi GET /display/{code}
class DisplayProductPayload(BaseModel):
    code: str
    product_sku: Optional[str]
    product_name: Optional[str]
    price: Optional[float]
    currency: Optional[str]
    description: Optional[str]
    image_url: Optional[str]
    updated_at: Optional[datetime]
