class MateriaAprobada {
    const property materia 
    const property nota
} 
class Carrera {
  const property materias ={} 
}
class Materia {
  const property inscriptos ={}
  const property enEspera ={}
  const cupo = 0
  const materiasRequisito ={}
  method cumpleRequisito(estudiante) = materiasRequisito.all({materia => estudiante.aprobo(materia)})
  method inscriptosOEnEspera() = inscriptos+enEspera
  method seInscribio(estudiante) =self.inscriptosOEnEspera().contains(estudiante)
}
class Estudiante {
    const cursada ={}
    const carrerasInscriptas =[] 
    method aprobar(materia, nota) {
        self.validarAprobar(materia)
      cursada.add(new MateriaAprobada(materia=materia ,nota=nota))
    }
    method validarAprobar(materia) {
      if(self.aprobo(materia)){
        self.error("ya aprobe esta materia")
      }
    }
    method cantidadAprobadas() =cursada.size()
    method promedio() = cursada.average({materiaAprobada=> materiaAprobada.nota()})
    method materiasAprobadas()=cursada.map({materiaAprobada=> materiaAprobada.materia()})
    method aprobo(materia) =self.materiasAprobadas().contains(materia)
    method materiasDeCarrerasInscriptas() =  carrerasInscriptas.flatMap({carrera=>carrera.materias()})
    method esMateriaDeCarrerasInscriptas(materia) = self.materiasDeCarrerasInscriptas().contains(materia)
    method puedeCursar(materia) = materia.cumpleRequisito(self)&&self.esMateriaDeCarrerasInscriptas(materia)&&(not materia.seInscribio(self))&&(not self.aprobo(materia))
} 