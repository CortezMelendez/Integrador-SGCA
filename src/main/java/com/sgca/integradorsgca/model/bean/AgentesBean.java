package com.sgca.integradorsgca.model.bean;

import java.sql.Timestamp;

public class AgentesBean {
    private int idAgente;
    private int idUsuario;
    private Timestamp fechaIngreso;
    private int estado;

    // Campos auxiliares para mostrar información del usuario en las vistas/listados
    private String nombreCompletoUsuario;
    private String correoUsuario;

    public AgentesBean() {
    }

    public AgentesBean(int idAgente, int idUsuario, Timestamp fechaIngreso, int estado) {
        this.idAgente = idAgente;
        this.idUsuario = idUsuario;
        this.fechaIngreso = fechaIngreso;
        this.estado = estado;
    }

    public AgentesBean(int idAgente, int idUsuario, Timestamp fechaIngreso, int estado, String nombreCompletoUsuario, String correoUsuario) {
        this.idAgente = idAgente;
        this.idUsuario = idUsuario;
        this.fechaIngreso = fechaIngreso;
        this.estado = estado;
        this.nombreCompletoUsuario = nombreCompletoUsuario;
        this.correoUsuario = correoUsuario;
    }

    public int getIdAgente() {
        return idAgente;
    }

    public void setIdAgente(int idAgente) {
        this.idAgente = idAgente;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Timestamp getFechaIngreso() {
        return fechaIngreso;
    }

    public void setFechaIngreso(Timestamp fechaIngreso) {
        this.fechaIngreso = fechaIngreso;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    public String getNombreCompletoUsuario() {
        return nombreCompletoUsuario;
    }

    public void setNombreCompletoUsuario(String nombreCompletoUsuario) {
        this.nombreCompletoUsuario = nombreCompletoUsuario;
    }

    public String getCorreoUsuario() {
        return correoUsuario;
    }

    public void setCorreoUsuario(String correoUsuario) {
        this.correoUsuario = correoUsuario;
    }
}