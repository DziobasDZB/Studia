package server;

import rmi.Calculator;
import gui.GUI;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

public class Server implements Calculator {
    
    private GUI gui;
    
    public Server(GUI g) {
        gui = g;
    }
    
    public void bindStub() {
        try {
            LocateRegistry.createRegistry(1099);
            Calculator stub = (Calculator) UnicastRemoteObject.exportObject(this, 1099);
            Registry reg = LocateRegistry.getRegistry();
            reg.bind("FIBB", stub);
            gui.getTextArea().setText(">>>>> Serwer gotowy do pracy.");
        } catch(Exception e) {
            gui.getTextArea().setText(gui.getTextArea().getText() + "\n>>>>> Wystąpił błąd: " + e.toString());
        }
    }
        
    @Override
    public String fib(String n) throws RemoteException {
        long f, f0 = 0, f1 = 1;
        String finalString = new String();
        
        if(Integer.parseInt(n) == 0) return finalString + f0 + "  ";
        
        finalString = f0 + "  " + f1 + "  ";
        
        for(int i = 1; i < Integer.parseInt(n); i++) {
            if(Integer.parseInt(n) > 1) {
                f = f0 + f1;
                f0 = f1;
                f1 = f;
            } else f = i;
            
            finalString += f + "  ";
        }
        
        return finalString;
    }

}
