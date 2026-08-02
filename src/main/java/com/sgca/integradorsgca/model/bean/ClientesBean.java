package com.sgca.integradorsgca.model.bean;

import java.sql.Timestamp;

public class ClientesBean {

    private int idCliente;
    private int idUsuario;
    private Integer idAgente; // Integer (Wrapper) permite manejar valores NULL en la BD
    private Timestamp fechaRegistro;

    // Campos para representar la vista en las tablas
    private String nombreCliente;
    private String correoCliente;
    private String nombreAgente;

    public ClientesBean() {
    }

    public ClientesBean(int idCliente, int idUsuario, Integer idAgente, Timestamp fechaRegistro) {
        this.idCliente = idCliente;
        this.idUsuario = idUsuario;
        this.idAgente = idAgente;
        this.fechaRegistro = fechaRegistro;
    }

    // Getters y Setters
    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Integer getIdAgente() {
        return idAgente;
    }

    public void setIdAgente(Integer idAgente) {
        this.idAgente = idAgente;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public String getCorreoCliente() {
        return correoCliente;
    }

    public void setCorreoCliente(String correoCliente) {
        this.correoCliente = correoCliente;
    }

    public String getNombreAgente() {
        return nombreAgente;
    }

    public void setNombreAgente(String nombreAgente) {
        this.nombreAgente = nombreAgente;
    }
}