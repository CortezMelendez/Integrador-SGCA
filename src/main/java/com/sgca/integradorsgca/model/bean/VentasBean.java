package com.sgca.integradorsgca.model.bean;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class VentasBean {
    private int id_venta;
    private ClientesBean cliente;
    private AgentesBean agente;
    private VehiculosBean vehiculo;
    private Timestamp fechaVenta;
    private double total;
    private List<DetalleVentaServiciosBean> detalles = new ArrayList<>();

    public VentasBean() {}

    public VentasBean(int id_venta, ClientesBean cliente, AgentesBean agente, VehiculosBean vehiculo, Timestamp fechaVenta, double total) {
        this.id_venta = id_venta;
        this.cliente = cliente;
        this.agente = agente;
        this.vehiculo = vehiculo;
        this.fechaVenta = fechaVenta;
        this.total = total;
    }

    public int getId_venta() {
        return id_venta;
    }

    public void setId_venta(int id_venta) {
        this.id_venta = id_venta;
    }

    public ClientesBean getCliente() {
        return cliente;
    }

    public void setCliente(ClientesBean cliente) {
        this.cliente = cliente;
    }

    public AgentesBean getAgente() {
        return agente;
    }

    public void setAgente(AgentesBean agente) {
        this.agente = agente;
    }

    public VehiculosBean getVehiculo() {
        return vehiculo;
    }

    public void setVehiculo(VehiculosBean vehiculo) {
        this.vehiculo = vehiculo;
    }

    public Timestamp getFechaVenta() {
        return fechaVenta;
    }

    public void setFechaVenta(Timestamp fechaVenta) {
        this.fechaVenta = fechaVenta;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public List<DetalleVentaServiciosBean> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<DetalleVentaServiciosBean> detalles) {
        this.detalles = detalles;
    }
}