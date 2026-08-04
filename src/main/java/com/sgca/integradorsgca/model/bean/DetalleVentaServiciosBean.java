package com.sgca.integradorsgca.model.bean;

public class DetalleVentaServiciosBean {
    private int id_detalle;
    private int id_venta;
    private ServiciosBean servicio;
    private double precio;

    public DetalleVentaServiciosBean() {}

    public DetalleVentaServiciosBean(int id_detalle, int id_venta, ServiciosBean servicio, double precio) {
        this.id_detalle = id_detalle;
        this.id_venta = id_venta;
        this.servicio = servicio;
        this.precio = precio;
    }

    public int getId_detalle() {
        return id_detalle;
    }

    public void setId_detalle(int id_detalle) {
        this.id_detalle = id_detalle;
    }

    public int getId_venta() {
        return id_venta;
    }

    public void setId_venta(int id_venta) {
        this.id_venta = id_venta;
    }

    public ServiciosBean getServicio() {
        return servicio;
    }

    public void setServicio(ServiciosBean servicio) {
        this.servicio = servicio;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }
}