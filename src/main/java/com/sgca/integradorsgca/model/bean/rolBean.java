package com.sgca.integradorsgca.model.bean;

public class rolBean {
    private int id_Rol;
    private String rol;
    private String descripcion;
    private int estado;

    public rolBean(){}

    public rolBean(int id_Rol, String rol, String descripcion, int Estado) {
        this.id_Rol = id_Rol;
        this.rol = rol;
        this.descripcion = descripcion;
        this.estado = Estado;
    }

    public int getId_Rol() {
        return id_Rol;
    }

    public void setId_Rol(int id_Rol) {
        this.id_Rol = id_Rol;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }
}
