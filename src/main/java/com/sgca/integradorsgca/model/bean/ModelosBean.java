package com.sgca.integradorsgca.model.bean;

public class ModelosBean {
    private int  id_Modelo;
    private int id_Marca;
    private String nombre;
    private int estado;

    //Objeto para la relacion, modelo - marca

    private MarcaBean marca = new MarcaBean();

    public ModelosBean() {}

    //Constructor para Registrar
    public ModelosBean( int id_Marca, String nombre, int estado) {
        this.id_Marca = id_Marca;
        this.nombre = nombre;
        this.estado = estado;
    }

    //Constructor para Actualizar
    public ModelosBean( int id_Modelo, int id_Marca, String nombre, int estado) {
        this.id_Modelo = id_Modelo;
        this.id_Marca = id_Marca;
        this.nombre = nombre;
        this.estado = estado;
    }

    public int getId_Modelo() {
        return id_Modelo;
    }

    public void setId_Modelo(int id_Modelo) {
        this.id_Modelo = id_Modelo;
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

    public MarcaBean getMarca() {
        return marca;
    }

    public void setMarca(MarcaBean marca) {
        this.marca = marca;
    }
}
