class MateriaAprobada {
  const property materia
  const property nota
}

class Carrera {
  const property materias = #{}
}

class Materia {
  const property inscriptos = #{}
  const property enEspera = []
  const cupo = 0
  const materiasRequisito = #{}
  
  method cumpleRequisito(estudiante) = materiasRequisito.all(
    { materia => estudiante.aprobo(materia) }
  )
  
  method inscriptosOEnEspera() = inscriptos + enEspera
  
  method estaInscriptoOEnEspera(
    estudiante
  ) = self.inscriptosOEnEspera().contains(estudiante)
  
  method quedoInscripto(estudiante) = inscriptos.contains(estudiante)
  
  method quedoEnEspera(estudiante) = enEspera.contains(estudiante)
  
  method inscribir(estudiante) {
    self.validarInscribir(estudiante)
    self.aListaDeEsperaOInscripto(estudiante)
  }
  
  method validarInscribir(estudiante) {
    if (not estudiante.puedeCursar(self)) self.error(
        "el estudiante no cumple los requisitos o ya esta inscripto en la materia "
      )
  }
  
  method aListaDeEsperaOInscripto(estudiante) {
    if (inscriptos.size() >= cupo) enEspera.add(estudiante)
    else inscriptos.add(estudiante)
  }
  
  method darDeBaja(estudiante) {
    inscriptos.remove(estudiante)
    self.inscribirEnEsperaDeExistir()
  }
  
  method inscribirEnEsperaDeExistir() {
    if (not enEspera.isEmpty()) {
      inscriptos.add(self.primeroEnEspera())
      enEspera.remove(self.primeroEnEspera())
    }
  }
  
  method primeroEnEspera() = enEspera.first()
}

class Estudiante {
  const cursada = #{}
  const carrerasInscriptas = []
  
  method aprobar(materia, nota) {
    self.validarAprobar(materia)
    cursada.add(new MateriaAprobada(materia = materia, nota = nota))
  }
  
  method validarAprobar(materia) {
    if (self.puedeAprobar(materia)) self.error("ya aprobe esta materia")
  }
  method puedeAprobar(materia) =self.aprobo(materia)&&self.esMateriaDeCarrerasInscriptas(materia)
  
  method cantidadAprobadas() = cursada.size()
  
  method promedio() = cursada.average(
    { materiaAprobada => materiaAprobada.nota() }
  )
  
  method materiasAprobadas() = cursada.map(
    { materiaAprobada => materiaAprobada.materia() }
  )
  
  method aprobo(materia) = self.materiasAprobadas().contains(materia)
  
  method materiasDeCarrerasInscriptas() = carrerasInscriptas.flatMap(
    { carrera => carrera.materias() }
  )
  
  method esMateriaDeCarrerasInscriptas(
    materia
  ) = self.materiasDeCarrerasInscriptas().contains(materia)
  
  method puedeCursar(materia) =materia.cumpleRequisito(
    self
  ) && self.esMateriaDeCarrerasInscriptas(
    materia
  ) && (not materia.estaInscriptoOEnEspera(self)) && (not self.aprobo(materia))
  
  method materiasDondeQuedoInscripto() = self.materiasDeCarrerasInscriptas().filter(
    { materia => materia.quedoInscripto(self) }
  )
  
  method materiasDondeQuedoEnEspera() = self.materiasDeCarrerasInscriptas().filter(
    { materia => materia.quedoEnEspera(self) }
  )
  method validarMateriasQueSePuedeIncribir(carrera) {
    if(not carrerasInscriptas.contains(carrera)){
      self.error("no estoy inscripto en esta carrera")
    }
  }
  method materiasQueSePuedeIncribir(carrera) {
    self.validarMateriasQueSePuedeIncribir(carrera)//lo valide por que en el enunciado dice que solo vale si el estudiante cursa la carrera(aunque no da error ni informacion erronea sin la validacion)
   return carrera.materias().filter(
    { materia => self.puedeCursar(materia) }
  )}
}