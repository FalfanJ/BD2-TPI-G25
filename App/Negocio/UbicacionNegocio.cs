using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class UbicacionNegocio
    {
        public List<Ubicacion> Listar()
        {
            List<Ubicacion> lista = new List<Ubicacion>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT Id_Ubicacion, NombreUbicacion FROM Ubicacion");
                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    Ubicacion aux = new Ubicacion();
                    aux.Id_Ubicacion = (int)datos.Lector["Id_Ubicacion"];
                    aux.NombreUbicacion = (string)datos.Lector["NombreUbicacion"];
                    lista.Add(aux);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }
    }
}
