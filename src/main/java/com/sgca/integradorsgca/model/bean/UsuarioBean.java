package com.sgca.integradorsgca.model.bean;

import java.sql.Timestamp;

public class UsuarioBean {
    private int id_usuario;
    private rolBean rol;
    private String nombre;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private String rfc;
    private String curp;
    private String correo;
    private String telefono;
    private String password;
    private int estado;
    private Timestamp fechaRegistro;


    public UsuarioBean() {}

    // 2. Constructor para registrar nuevos usuarios (sin ID ni Fecha)
    public UsuarioBean(rolBean rol, String nombre, String apellidoPaterno, String apellidoMaterno,
                       String rfc, String curp, String correo, String telefono, String password, int estado) {
        this.rol = rol;
        this.nombre = nombre;
        this.apellidoPaterno = apellidoPaterno;
        this.apellidoMaterno = apellidoMaterno;
        this.rfc = rfc;
        this.curp = curp;
        this.correo = correo;
        this.telefono = telefono;
        this.password = password;
        this.estado = estado;
    }

    // 3. Constructor Completo (para listar datos leídos de la DB)
    public UsuarioBean(int id_usuario, rolBean rol, String nombre, String apellidoPaterno,
                       String apellidoMaterno, String rfc, String curp, String correo,
                       String telefono, String password, int estado, Timestamp fechaRegistro) {
        this.id_usuario = id_usuario;
        this.rol = rol;
        this.nombre = nombre;
        this.apellidoPaterno = apellidoPaterno;
        this.apellidoMaterno = apellidoMaterno;
        this.rfc = rfc;
        this.curp = curp;
        this.correo = correo;
        this.telefono = telefono;
        this.password = password;
        this.estado = estado;
        this.fechaRegistro = fechaRegistro;
    }



    public int getId_usuario() {
        return id_usuario;
    }

    public void setId_usuario(int id_usuario) {
        this.id_usuario = id_usuario;
    }

    public rolBean getRol() {
        return rol;
    }

    public void setRol(rolBean rol) {
        this.rol = rol;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellidoPaterno() {
        return apellidoPaterno;
    }

    public void setApellidoPaterno(String apellidoPaterno) {
        this.apellidoPaterno = apellidoPaterno;
    }

    public String getApellidoMaterno() {
        return apellidoMaterno;
    }

    public void setApellidoMaterno(String apellidoMaterno) {
        this.apellidoMaterno = apellidoMaterno;
    }

    public String getRfc() {
        return rfc;
    }

    public void setRfc(String rfc) {
        this.rfc = rfc;
    }

    public String getCurp() {
        return curp;
    }

    public void setCurp(String curp) {
        this.curp = curp;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
}