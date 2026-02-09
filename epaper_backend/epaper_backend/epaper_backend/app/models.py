# app/models.py
from sqlalchemy import (
    Column,
    String,
    Integer,
    BigInteger,
    Text,
    Enum,
    DateTime,
    DECIMAL,
    ForeignKey,
)
from sqlalchemy.orm import relationship
from datetime import datetime

from .database import Base


class Product(Base):
    __tablename__ = "products"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    sku = Column(String(64), unique=True, nullable=False, index=True)
    name = Column(String(255), nullable=False)
    price = Column(DECIMAL(10, 2), nullable=False)
    currency = Column(String(3), nullable=False, default="VND")
    description = Column(Text)
    image_url = Column(String(500))
    status = Column(
        Enum("active", "inactive", "deleted", name="product_status"),
        nullable=False,
        default="active",
    )
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    displays = relationship("Display", back_populates="product")


class Display(Base):
    __tablename__ = "displays"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    code = Column(String(64), unique=True, nullable=False, index=True)
    name = Column(String(255))
    location = Column(String(255))
    product_id = Column(BigInteger, ForeignKey("products.id"), nullable=True)
    battery_level = Column(Integer)        # map cho TINYINT UNSIGNED
    signal_strength = Column(Integer)      # map cho TINYINT
    last_seen_at = Column(DateTime)
    status = Column(
        Enum("online", "offline", "error", name="display_status"),
        nullable=False,
        default="offline",
    )
    firmware_version = Column(String(32))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    product = relationship("Product", back_populates="displays")
    status_logs = relationship("DisplayStatusLog", back_populates="display")


class DisplayStatusLog(Base):
    __tablename__ = "display_status_logs"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    display_id = Column(BigInteger, ForeignKey("displays.id"), nullable=False)
    battery_level = Column(Integer)
    signal_strength = Column(Integer)
    status = Column(
        Enum("online", "offline", "error", name="log_display_status"),
        nullable=True,
    )
    firmware_version = Column(String(32))
    created_at = Column(DateTime, default=datetime.utcnow)

    display = relationship("Display", back_populates="status_logs")
