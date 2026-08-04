package com.sgca.integradorsgca.model.bean;

public class TiposServicioBean {
    private int id_tipo_servicio;
    private String nombre;

    public TiposServicioBean() {}

    public TiposServicioBean(int id_tipo_servicio, String nombre) {
        this.id_tipo_servicio = id_tipo_servicio;
        this.nombre = nombre;
    }

    public int getId_tipo_servicio() {
        return id_tipo_servicio;
    }

    public void setId_tipo_servicio(int id_tipo_servicio) {
        this.id_tipo_servicio = id_tipo_servicio;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
}