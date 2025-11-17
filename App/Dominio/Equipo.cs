using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Equipo
    {
        public int Id_Equipo { get; set; }
        public int Tipo_Equipo { get; set; }
        public Ubicacion Ubicacion { get; set; }
        public string Nombre { get; set; }
        public Marca Marca { get; set; }
        public string Modelo { get; set; }
        public string NumeroSerie { get; set; }
        public DateTime? Fecha_adquisicion { get; set; }
        public string Estado { get; set; }
    }
}
