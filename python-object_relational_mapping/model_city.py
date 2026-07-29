#!/usr/bin/python3
"""Contains the class definition of a City."""
from model_state import Base
from sqlalchemy import Column, ForeignKey, Integer, String


class City(Base):
    """City class linking to the MySQL table cities."""
    __tablename__ = 'cities'
    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    name = Column(String(128), nullable=False)
    state_id = Column(Integer, ForeignKey('states.id'), nullable=False)
