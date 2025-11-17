using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class AccesoDatos
    {
        private SqlConnection conexion;
        private SqlCommand comando;
        private SqlDataReader lector;

        public SqlDataReader Lector
        {
            get { return lector; }
        }
        public AccesoDatos()
        {
            conexion = new SqlConnection("server=.\\SQLEXPRESS; database=BD2_TPI_G25; integrated security=true");
            comando = new SqlCommand();
        }
        public void SetearConsulta(string consulta)
        {
            comando.Parameters.Clear(); // Limpieza automática
            comando.CommandType = System.Data.CommandType.Text;
            comando.CommandText = consulta;
        }
        public void SetearProcedimiento(string sp)
        {
            comando.CommandType = System.Data.CommandType.StoredProcedure;
            comando.CommandText = sp;
        }
        public void EjecutarLectura()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                lector = comando.ExecuteReader();
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        public void EjecutarAccion()
        {
            comando.Connection = conexion;
            try
            {
                if(conexion.State != System.Data.ConnectionState.Open) // primero verifica si hay una conexion abierta, si la hay no abre, si no la hay abre una
                    conexion.Open();
                comando.ExecuteNonQuery();
                comando.Parameters.Clear(); // limpia los parametros
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }
        public void SetearParametro(string nombreParametro, object valor)
        {
            if (!(valor == null)) // si el valor recibido es nulo entonces le envia a la base de datos un valor nulo para que no explote
            {
                comando.Parameters.AddWithValue(nombreParametro, valor);
            }
            else
            {
                comando.Parameters.AddWithValue(nombreParametro, DBNull.Value); 
            }
        }
        public void CerrarConexion()
        {
            if (lector != null)
                lector.Close();
            conexion.Close();
        }
        public object EjecutarScalar() // Igual que EjecutarAccion solo que este recibe un elemento que devuelve la base de datos
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                return comando.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
