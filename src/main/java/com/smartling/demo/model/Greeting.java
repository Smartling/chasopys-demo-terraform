package com.smartling.demo.model;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.io.Serializable;

@AllArgsConstructor
@Getter
public class Greeting implements Serializable
{
    private String greeting;
}
