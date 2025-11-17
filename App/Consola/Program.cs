using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Consola
{
    internal class Program
    {
        static void Main(string[] args)
        {
            List<Empleado> listEmp = new List<Empleado>();
            EmpleadoNegocio negEmp = new EmpleadoNegocio();
            listEmp = negEmp.Listar();
            foreach (Empleado item in listEmp)
            {
                Console.WriteLine(item.Id_Empleado);
                Console.WriteLine(item.Nombre);
                Console.WriteLine(item.Apellido);
                Console.WriteLine(item.Ubicacion.Id_Ubicacion);
                Console.WriteLine(item.Correo);
                Console.WriteLine(item.Telefono);
                Console.WriteLine(item.Rol.Id_Rol);

            }
            List<Equipo> listequ = new List<Equipo>();
            EquipoNegocio negequio = new EquipoNegocio();
            listequ = negequio.Listar();
            foreach (Equipo item in listequ)
            {
                Console.WriteLine(item.Id_Equipo);
                Console.WriteLine(item.Marca.Id_Marca);
                Console.WriteLine(item.Ubicacion.Id_Ubicacion);
                Console.WriteLine(item.Nombre);

            }
        }
    }
}
