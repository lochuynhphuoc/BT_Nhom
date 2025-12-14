package com.group.trainapp.model;

public class Train {
    private int id;
    private String code;
    private String name;
    private int totalSeats;

    public Train() {
    }

    public Train(int id, String code, String name, int totalSeats) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.totalSeats = totalSeats;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }
}
