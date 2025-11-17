using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Empleado
    {
        public int Id_Empleado { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public Ubicacion Ubicacion { get; set; }
        public string Correo { get; set; }
        public int? Telefono { get; set; }
        public Rol Rol { get; set; }
    }
}
