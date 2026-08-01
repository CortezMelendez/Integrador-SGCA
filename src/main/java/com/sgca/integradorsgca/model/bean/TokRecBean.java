package com.sgca.integradorsgca.model.bean;

import java.util.Date;

public class TokRecBean {
    private int idToken;
    private int idUsuario;
    private String token;
    private Date expiracion;
    private int usado;

    public TokRecBean() {}

    public TokRecBean(int IdToken, int IdUsuario, String token, Date expiracion, int usado) {

        this.idUsuario = IdUsuario;
        this.token = token;
        this.expiracion = expiracion;
        this.usado = usado;
    }

    public int getIdToken() {
        return idToken;
    }

    public void setIdToken(int idToken) {
        this.idToken = idToken;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getExpiracion() {
        return expiracion;
    }

    public void setExpiracion(Date expiracion) {
        this.expiracion = expiracion;
    }

    public int getUsado() {
        return usado;
    }

    public void setUsado(int usado) {
        this.usado = usado;
    }
}
