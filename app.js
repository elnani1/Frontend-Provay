const API_URL = "http://localhost:5019";

let vistaActual = "activas";
let peticionEnCurso = false;
let idEdicionActual = null;
let listaSolicitudesMemoria = [];

function cambiarVista(vista) {
  vistaActual = vista;
  const btnActivas = document.getElementById("btn-activas");
  const btnHistorial = document.getElementById("btn-historial");

  if (vista === "activas") {
    btnActivas.className = "boton-primario";
    btnHistorial.className = "boton-secundario";
  } else {
    btnActivas.className = "boton-secundario";
    btnHistorial.className = "boton-primario";
  }
  cargarSolicitudes();
}

async function cargarSolicitudes() {
  try {
    const ruta = vistaActual === "activas" ? "/solicitudes/activas" : "/solicitudes/historial";
    const respuesta = await fetch(`${API_URL}${ruta}`);
    if (!respuesta.ok) throw new Error(`HTTP Error: ${respuesta.status}`);

    listaSolicitudesMemoria = await respuesta.json();
    const tabla = document.getElementById("cuerpo-tabla");
    tabla.innerHTML = "";

    if (listaSolicitudesMemoria.length === 0) {
      tabla.innerHTML = `<tr><td colspan="8" style="text-align: center; color: #9ca3af; padding: 24px;">No hay registros en esta sección.</td></tr>`;
      return;
    }

    listaSolicitudesMemoria.forEach(s => {
      const clasePrioridad = s.prioridad === 'Alta' ? 'badge-alta' : (s.prioridad === 'Media' ? 'badge-media' : 'badge-baja');
      const claseEstado = s.estado === 'En Proceso' ? 'badge-proceso' : (s.estado === 'Cerrado' ? 'badge-baja' : 'badge-pendiente');

      let infoFecha = `<div><span style="font-size:0.75rem; color:#64748b;">Reporte:</span> ${s.fechaSolicitud}</div>`;
      if (s.categoria === 'Preventivo' && s.fechaProgramada) {
        infoFecha += `
          <div style="margin-top: 2px;"><span style="font-size:0.75rem; color:#2563eb; font-weight:600;">Prog:</span> ${s.fechaProgramada}</div>
          <div style="font-size: 0.7rem; color: #64748b;">(${s.frecuencia || 'Única vez'})</div>
        `;
      }

      let detalleTrabajo = `<div>${s.descripcion}</div>`;
      if (vistaActual === 'historial' && s.notaResolucion) {
        detalleTrabajo += `<div style="margin-top: 4px; font-size: 0.75rem; color: #059669; font-weight: 500;"><strong>Resolución:</strong> ${s.notaResolucion}</div>`;
      }

      tabla.innerHTML += `
        <tr>
          <td><strong>#${s.id}</strong></td>
          <td>${infoFecha}</td>
          <td>${s.areaEquipo}</td>
          <td><span style="font-weight: 600; color: #334155;">${s.nombreTecnico}</span></td>
          <td>${detalleTrabajo}</td>
          <td><span class="badge ${clasePrioridad}">${s.prioridad}</span></td>
          <td><span class="badge ${claseEstado}">${s.estado}</span></td>
          <td class="texto-derecha">
            ${s.estado === 'Pendiente' ? `<button class="boton-accion btn-iniciar" onclick="actualizarEstado(${s.id}, 'En Proceso')">Iniciar</button>` : ''}
            ${s.estado === 'En Proceso' ? `<button class="boton-accion btn-cerrar" onclick="cerrarConNota(${s.id})">Cerrar</button>` : ''}
            <button class="boton-accion btn-editar" onclick="abrirModalEdicion(${s.id})">Editar</button>
            <button class="boton-accion btn-eliminar" onclick="eliminarSolicitud(${s.id})">Borrar</button>
          </td>
        </tr>
      `;
    });
  } catch (error) {
    console.error("Error al cargar solicitudes:", error);
  }
}

function abrirModalEdicion(id) {
  const solicitud = listaSolicitudesMemoria.find(s => s.id === id);
  if (!solicitud) return;

  idEdicionActual = id;
  document.querySelector("#modal-reporte h3").innerText = `Editar Reporte #${id}`;
  document.querySelector("#formulario-solicitud button[type='submit']").innerText = "Guardar Cambios";

  document.getElementById("categoria").value = solicitud.categoria;
  document.getElementById("prioridad").value = solicitud.prioridad;
  document.getElementById("descripcion").value = solicitud.descripcion;
  document.getElementById("idTecnicoAsignado").value = solicitud.idTecnicoAsignado || "";

  const seccionPrev = document.getElementById("seccion-preventivo");
  const inputFecha = document.getElementById("fechaProgramada");

  if (solicitud.categoria === "Preventivo") {
    seccionPrev.classList.remove("oculto");
    inputFecha.required = true;
    inputFecha.value = solicitud.fechaProgramada || "";
    document.getElementById("frecuencia").value = solicitud.frecuencia || "Única vez";
  } else {
    seccionPrev.classList.add("oculto");
    inputFecha.required = false;
    inputFecha.value = "";
  }

  document.getElementById("modal-reporte").classList.remove("oculto");
}

async function eliminarSolicitud(id) {
  if (!confirm(`¿Está segura de que desea eliminar el reporte #${id}? Esta acción no se puede deshacer.`)) {
    return;
  }

  try {
    const respuesta = await fetch(`${API_URL}/solicitudes/${id}`, {
      method: "DELETE"
    });

    if (respuesta.ok) {
      cargarSolicitudes();
    } else {
      alert("No se pudo eliminar el reporte.");
    }
  } catch (error) {
    console.error("Error al eliminar solicitud:", error);
  }
}

async function actualizarEstado(id, nuevoEstado, notaResolucion = null) {
  try {
    const res = await fetch(`${API_URL}/solicitudes/${id}/estado`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ nuevoEstado: nuevoEstado, notaResolucion: notaResolucion })
    });
    if (!res.ok) throw new Error("Error en la respuesta del servidor");
    cargarSolicitudes();
  } catch (error) {
    console.error("Error al actualizar estado:", error);
  }
}

function cerrarConNota(id) {
  const nota = prompt("Ingrese nota u observaciones de cierre:");
  if (nota !== null) {
    actualizarEstado(id, "Cerrado", nota.trim() === "" ? "Finalizado sin observaciones" : nota.trim());
  }
}

document.getElementById("categoria").addEventListener("change", (e) => {
  const seccion = document.getElementById("seccion-preventivo");
  const inputFecha = document.getElementById("fechaProgramada");
  if (e.target.value === "Preventivo") {
    seccion.classList.remove("oculto");
    inputFecha.required = true;
  } else {
    seccion.classList.add("oculto");
    inputFecha.required = false;
    inputFecha.value = "";
  }
});

// Manejo unificado de Guardar (Creación o Edición)
document.getElementById("formulario-solicitud").addEventListener("submit", async function(evento) {
  evento.preventDefault();

  if (peticionEnCurso) return;
  peticionEnCurso = true;

  const botonGuardar = this.querySelector("button[type='submit']");
  if (botonGuardar) {
    botonGuardar.disabled = true;
    botonGuardar.innerText = "Guardando...";
  }

  const idAreaVal = document.getElementById("idAreaEquipo").value;
  const idTecnicoVal = document.getElementById("idTecnicoAsignado").value;
  const esPreventivo = document.getElementById("categoria").value === "Preventivo";

  const payload = {
    descripcion: document.getElementById("descripcion").value,
    prioridad: document.getElementById("prioridad").value,
    categoria: document.getElementById("categoria").value,
    idAreaEquipo: idAreaVal ? parseInt(idAreaVal) : null,
    fechaProgramada: esPreventivo ? (document.getElementById("fechaProgramada").value || null) : null,
    frecuencia: esPreventivo ? document.getElementById("frecuencia").value : null,
    idTecnicoAsignado: idTecnicoVal ? parseInt(idTecnicoVal) : null
  };

  try {
    let url = `${API_URL}/solicitudes`;
    let metodo = "POST";

    if (idEdicionActual) {
      url = `${API_URL}/solicitudes/${idEdicionActual}`;
      metodo = "PUT";
    } else {
      payload.estado = "Pendiente";
    }

    const respuesta = await fetch(url, {
      method: metodo,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });

    if (respuesta.ok) {
      cerrarModal();
      cargarSolicitudes();
    }
  } catch (error) {
    console.error("Error al procesar solicitud:", error);
  } finally {
    peticionEnCurso = false;
    if (botonGuardar) {
      botonGuardar.disabled = false;
      botonGuardar.innerText = idEdicionActual ? "Guardar Cambios" : "Guardar Reporte";
    }
  }
});

function abrirModal() {
  idEdicionActual = null;
  document.querySelector("#modal-reporte h3").innerText = "Nuevo Reporte de Falla";
  document.querySelector("#formulario-solicitud button[type='submit']").innerText = "Guardar Reporte";
  document.getElementById("formulario-solicitud").reset();
  document.getElementById("seccion-preventivo").classList.add("oculto");
  document.getElementById("modal-reporte").classList.remove("oculto");
}

function cerrarModal() {
  idEdicionActual = null;
  document.getElementById("formulario-solicitud").reset();
  document.getElementById("modal-reporte").classList.add("oculto");
}

cargarSolicitudes();