package client;

import rmi.Calculator;
import gui.GUI;
import java.awt.Color;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class Client {

    private GUI gui;
    private Calculator stub;
    
    public Client(GUI g) {
        gui = g;
    }
    
    public Calculator getStub() {
        return stub;
    }
    
    public void connectServer() {
        try {
            Registry reg = LocateRegistry.getRegistry();
            Calculator stub = (Calculator) reg.lookup("FIBB");
            this.stub = stub;
        } catch(Exception e) {
            gui.getResultText().setDisabledTextColor(Color.red);
            gui.getResultText().setText("Brak połączenia z serwerem.");
        }
    }
    
}
