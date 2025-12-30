import 'package:flutter/material.dart';

class EtapaData {
  final String nombre;
  final Color color;
  final String imagen;
  final String descripcion;
  final int totalSecciones;
  final int seccionesCompletadas;
  final List<String> objetivos;

  EtapaData({
    required this.nombre,
    required this.color,
    required this.imagen,
    required this.descripcion,
    required this.totalSecciones,
    required this.seccionesCompletadas,
    required this.objetivos,
  });
}

final List<EtapaData> etapasData = [
  EtapaData(
    nombre: 'Primero de Primaria - Jardín de la Vida',
    color: Colors.green,
    imagen: 'lib/assets/images/etapas/etapa1.svg',
    descripcion:
        '¿Qué son los seres vivos? La planta y sus partes. Cuidado de las plantas y animales.',
    totalSecciones: 2, // Actualizado a 2 secciones
    seccionesCompletadas: 0,
    objetivos: [
      'Identificar qué son los seres vivos',
      'Conocer las partes de una planta',
      'Aprender el cuidado básico de plantas y animales',
      'Reconocer la importancia del agua, aire y suelo'
    ],
  ),
  EtapaData(
    nombre: 'Segundo de Primaria - Bosque del Cuidado Ambiental',
    color: Colors.orange,
    imagen: 'lib/assets/images/etapas/etapa2.svg',
    descripcion:
        'Las plantas y sus funciones. Los animales y sus características. Clasificación de materiales. Fenómenos del clima. Cuidado del ambiente. Fuerzas simples. El sonido.',
    totalSecciones: 2, // Actualizado a 2 secciones
    seccionesCompletadas: 0,
    objetivos: [
      'Conocer las funciones de las plantas',
      'Clasificar animales y materiales',
      'Entender el clima y el cuidado ambiental',
      'Explorar fuerzas simples y el sonido'
    ],
  ),
  EtapaData(
    nombre: 'Tercero de Primaria - Ecosistema Acuático',
    color: Colors.blue,
    imagen: 'lib/assets/images/etapas/etapa3.svg',
    descripcion:
        'Importancia de las plantas en el ecosistema. Ciclo del agua y propiedades del aire.',
    totalSecciones: 2, // Actualizado a 2 secciones
    seccionesCompletadas: 0,
    objetivos: [
      'Comprender la importancia de las plantas',
      'Conocer qué es un ecosistema',
      'Estudiar el ciclo del agua',
      'Entender las propiedades del aire y suelo'
    ],
  ),
  EtapaData(
    nombre: 'Cuarto de Primaria - Región Andina',
    color: Colors.purple,
    imagen: 'lib/assets/images/etapas/etapa4.svg',
    descripcion:
        'Ecosistemas y su clasificación. Red alimenticia. Función y conservación del suelo.',
    totalSecciones: 2, // Actualizado a 2 secciones
    seccionesCompletadas: 0,
    objetivos: [
      'Clasificar diferentes ecosistemas',
      'Entender las redes alimenticias',
      'Conocer las propiedades del aire',
      'Aprender sobre función y conservación del suelo'
    ],
  ),
  EtapaData(
    nombre: 'Quinto de Primaria - Desiertos y Humedales',
    color: Colors.amber,
    imagen: 'lib/assets/images/etapas/etapa5.svg',
    descripcion:
        'Factores del ecosistema. Hábitat y nicho ecológico. Importancia del agua, aire y suelo.',
    totalSecciones: 2, // Actualizado a 2 secciones
    seccionesCompletadas: 0,
    objetivos: [
      'Identificar factores del ecosistema',
      'Diferenciar hábitat y nicho ecológico',
      'Estudiar relaciones interespecíficas',
      'Valorar la importancia del agua, aire y suelo'
    ],
  ),
  EtapaData(
    nombre: 'Sexto de Primaria - Ecosistema Global',
    color: Colors.deepPurple,
    imagen: 'lib/assets/images/etapas/etapa6.svg',
    descripcion:
        'Introducción a la biología. Biodiversidad y niveles de organización de los seres vivos.',
    totalSecciones: 2, // Actualizado a 2 secciones
    seccionesCompletadas: 0,
    objetivos: [
      'Introducción básica a la biología',
      'Entender la biodiversidad',
      'Conocer niveles de organización',
      'Estudiar ecosistemas y factores bióticos/abióticos'
    ],
  ),
  // Las etapas 7-9 permanecen como están pero con sus valores originales
  EtapaData(
    nombre: 'Movilidad Sostenible',
    color: Colors.lime,
    imagen: 'lib/assets/images/etapas/etapa7.svg',
    descripcion:
        'Aprende sobre formas de transporte que respetan el medio ambiente.',
    totalSecciones: 7,
    seccionesCompletadas: 0,
    objetivos: [
      'Conocer alternativas de transporte sostenible',
      'Calcular la huella de carbono del transporte',
      'Planificar rutas eficientes',
      'Promover la movilidad activa'
    ],
  ),
  EtapaData(
    nombre: 'Cambio Climático',
    color: Colors.orange,
    imagen: 'lib/assets/images/etapas/etapa8.svg',
    descripcion:
        'Entiende las causas y consecuencias del cambio climático y qué podemos hacer al respecto.',
    totalSecciones: 10,
    seccionesCompletadas: 0,
    objetivos: [
      'Comprender las causas del cambio climático',
      'Identificar sus impactos globales y locales',
      'Conocer los acuerdos internacionales',
      'Implementar acciones para reducir emisiones'
    ],
  ),
  EtapaData(
    nombre: 'Tecnología Verde',
    color: Colors.teal,
    imagen: 'lib/assets/images/etapas/etapa9.svg',
    descripcion:
        'Descubre cómo la tecnología puede contribuir a un futuro más sostenible.',
    totalSecciones: 8,
    seccionesCompletadas: 0,
    objetivos: [
      'Conocer las innovaciones tecnológicas verdes',
      'Entender el papel de la IA en la sostenibilidad',
      'Aplicar tecnología para la conservación',
      'Promover soluciones tecnológicas sostenibles'
    ],
  ),
];
