using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class BaseDeConocimiento
    {
        public long Id_Articulo { get; set; }
        public string Titulo { get; set; }
        public string Solucion { get; set; }
        public Empleado Autor { get; set; }
    }
}
