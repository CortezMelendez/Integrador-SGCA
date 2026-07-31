package com.sgca.integradorsgca.model.bean;

import java.io.Serializable;

public class MarcaBean implements Serializable {
    private int id_Marca;
    private String nombre;
    private int estado;

    public MarcaBean(){}

    public MarcaBean(int id_Marca, String nombre, int estado) {
        this.id_Marca = id_Marca;
        this.nombre = nombre;
        this.estado = estado;
    }

    public int getId_Marca() {
        return id_Marca;
    }

    public void setId_Marca(int id_Marca) {
        this.id_Marca = id_Marca;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }
}
