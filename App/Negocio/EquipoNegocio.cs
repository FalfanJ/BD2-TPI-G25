using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class EquipoNegocio
    {
        // listar equipos para tickets
        // En EquipoNegocio.cs

        public List<Equipo> ListarPorCliente(int idCliente)
        {
            List<Equipo> lista = new List<Equipo>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Esta consulta ahora une los equipos asignados al cliente
                // CON el equipo "Otro" que acabamos de crear.
                string consulta = @"
            SELECT E.Id_Equipo, E.Nombre 
            FROM Equipo E
            INNER JOIN EquipoEmpleado EE ON E.Id_Equipo = EE.Id_Equipo
            WHERE EE.Id_Empleado = @idCliente

            UNION

            SELECT Id_Equipo, Nombre
            FROM Equipo
            WHERE Nombre LIKE 'Otro (%)'
            ";

                datos.SetearConsulta(consulta);
                datos.SetearParametro("@idCliente", idCliente);
                datos.EjecutarLectura();

                while (datos.Lector.Read())
                {
                    Equipo aux = new Equipo();
                    aux.Id_Equipo = (int)datos.Lector["Id_Equipo"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
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

        // Este método ahora es perfecto para el panel del Técnico
        public List<Equipo> Listar()
        {
            List<Equipo> lista = new List<Equipo>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                // 1. Consultamos la VISTA, no la tabla
                datos.SetearConsulta(@"SELECT Id_Equipo, Tipo_Equipo, NombreUbicacion, Nombre, 
                                            Marca, Modelo, NumeroSerie, Fecha_adquisicion, Estado 
                                      FROM InventarioEquipos");

                datos.EjecutarLectura();
                while (datos.Lector.Read())
                {
                    Equipo aux = new Equipo();
                    aux.Id_Equipo = (int)datos.Lector["Id_Equipo"];
                    aux.Tipo_Equipo = (int)datos.Lector["Tipo_Equipo"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Estado = (string)datos.Lector["Estado"];

                    // 2. Cargamos los nombres de las tablas relacionadas (manejando NULLs)
                    aux.Ubicacion = new Ubicacion();
                    if (!(datos.Lector["NombreUbicacion"] is DBNull))
                        aux.Ubicacion.NombreUbicacion = (string)datos.Lector["NombreUbicacion"];

                    aux.Marca = new Marca();
                    if (!(datos.Lector["Marca"] is DBNull))
                        aux.Marca.Nombre = (string)datos.Lector["Marca"];

                    // 3. Manejamos los otros campos que pueden ser NULL
                    if (!(datos.Lector["Modelo"] is DBNull))
                        aux.Modelo = (string)datos.Lector["Modelo"];

                    if (!(datos.Lector["NumeroSerie"] is DBNull))
                        aux.NumeroSerie = (string)datos.Lector["NumeroSerie"];

                    if (!(datos.Lector["Fecha_adquisicion"] is DBNull))
                        aux.Fecha_adquisicion = (DateTime?)datos.Lector["Fecha_adquisicion"];

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