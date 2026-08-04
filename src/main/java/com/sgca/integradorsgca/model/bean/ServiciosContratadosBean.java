package com.sgca.integradorsgca.model.bean;

import java.sql.Timestamp;

public class ServiciosContratadosBean {
    private int id_contratado;
    private ClientesBean cliente;
    private VehiculosBean vehiculo;
    private ServiciosBean servicio;
    private Timestamp fechaContratacion;
    private String estado; // Ej: 'PENDIENTE', 'EN_PROCESO', 'COMPLETADO', 'CANCELADO'
    private double precioAplicado;

    public ServiciosContratadosBean() {}

    public ServiciosContratadosBean(int id_contratado, ClientesBean cliente, VehiculosBean vehiculo,
                                    ServiciosBean servicio, Timestamp fechaContratacion,
                                    String estado, double precioAplicado) {
        this.id_contratado = id_contratado;
        this.cliente = cliente;
        this.vehiculo = vehiculo;
        this.servicio = servicio;
        this.fechaContratacion = fechaContratacion;
        this.estado = estado;
        this.precioAplicado = precioAplicado;
    }

    public int getId_contratado() {
        return id_contratado;
    }

    public void setId_contratado(int id_contratado) {
        this.id_contratado = id_contratado;
    }

    public ClientesBean getCliente() {
        return cliente;
    }

    public void setCliente(ClientesBean cliente) {
        this.cliente = cliente;
    }

    public VehiculosBean getVehiculo() {
        return vehiculo;
    }

    public void setVehiculo(VehiculosBean vehiculo) {
        this.vehiculo = vehiculo;
    }

    public ServiciosBean getServicio() {
        return servicio;
    }

    public void setServicio(ServiciosBean servicio) {
        this.servicio = servicio;
    }

    public Timestamp getFechaContratacion() {
        return fechaContratacion;
    }

    public void setFechaContratacion(Timestamp fechaContratacion) {
        this.fechaContratacion = fechaContratacion;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public double getPrecioAplicado() {
        return precioAplicado;
    }

    public void setPrecioAplicado(double precioAplicado) {
        this.precioAplicado = precioAplicado;
    }
}