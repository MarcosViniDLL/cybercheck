import 'package:flutter/material.dart';
import 'package:cybercheck/screens/home.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffeef2f6),// Defina a cor de fundo desejada
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.jpeg',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 50), // Espaçamento entre a logo e o botão
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Text(
                  'Entrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF25BBFD), // Cor de fundo do botão
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
