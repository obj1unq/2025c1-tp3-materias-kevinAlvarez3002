class MateriaAprobada {
    const property materia 
    const property nota
}
class Esctudiante {
    const materiasAprobadas ={}
    method aprobar(materia, nota) {
      materiasAprobadas.add(new MateriaAprobada(materia=materia ,nota=nota))
    }
    method cantidadAprobadas() =materiasAprobadas.size()
    method promedio() = materiasAprobadas.average({materiaAprobada=> materiaAprobada.nota()})
    method aprobo(materia) =materiasAprobadas.contains({materiaAprobada=> materiaAprobada.materia()==materia}) 
}