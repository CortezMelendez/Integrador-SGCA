package com.sgca.integradorsgca.model.bean;

public class ServiciosBean {
    private int id_servicio;
    private TiposServicioBean tipoServicio; // Asociación FK -> ADMIN.TIPOS_SERVICIO
    private String nombre;
    private String descripcion;
    private double precio;
    private int estado;

    public ServiciosBean() {}

    public ServiciosBean(int id_servicio, TiposServicioBean tipoServicio, String nombre, String descripcion, double precio, int estado) {
        this.id_servicio = id_servicio;
        this.tipoServicio = tipoServicio;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precio = precio;
        this.estado = estado;
    }

    public int getId_servicio() {
        return id_servicio;
    }

    public void setId_servicio(int id_servicio) {
        this.id_servicio = id_servicio;
    }

    public TiposServicioBean getTipoServicio() {
        return tipoServicio;
    }

    public void setTipoServicio(TiposServicioBean tipoServicio) {
        this.tipoServicio = tipoServicio;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }
}