# Trabajo Práctico Final – Marketplace Descentralizado
## Contrato 1 - Marketplace

**Materia:** Seminario de Lenguajes – Opción Rust  
**Tecnología:** Rust + Ink! + Substrate  
**Cobertura de tests requerida:** ≥ 85%  
**Entregas:**  
- ⭕ Primera entrega obligatoria: **18 de julio**  
- ✅ Entrega final completa: **Antes de finalizar 2025**

<img width="8334" height="4167" alt="image" src="https://github.com/user-attachments/assets/9bc5857c-5349-45ab-9e2b-a3edac75840b" />

---

## 📜 Introducción

El presente trabajo práctico final tiene como objetivo integrar los conocimientos adquiridos durante el cursado de la materia **Seminario de Lenguajes – Opción Rust**, aplicando conceptos de programación en Rust orientados al desarrollo de contratos inteligentes sobre la plataforma **Substrate** utilizando el framework **Ink!**.

La consigna propone desarrollar una **plataforma descentralizada de compra-venta de productos**, inspirada en modelos como MercadoLibre, pero ejecutada completamente en un entorno blockchain. El sistema deberá dividirse en **dos contratos inteligentes**: uno encargado de gestionar la lógica principal del marketplace y otro destinado a la generación de reportes a partir de los datos públicos del primero.

El proyecto busca que el estudiante no solo practique la sintaxis y semántica de Rust, sino que también comprenda el diseño modular de contratos inteligentes, la separación de responsabilidades, la validación de roles y permisos, y la importancia de la transparencia, trazabilidad y reputación en contextos descentralizados.

Se espera que las entregas incluyan una implementación funcional, correctamente testeada, documentada y con una cobertura de pruebas mínima del 85%.

---

## Contrato 1 – `MarketplacePrincipal` (Core funcional + reputación)

### Funcionalidades

#### 👤 Registro y gestión de usuarios
- Registro de usuario con rol: `Comprador`, `Vendedor` o ambos.
- Posibilidad de modificar roles posteriores.

#### 📦 Publicación de productos
- Publicar producto con nombre, descripción, precio, cantidad y categoría.
- Solo disponible para usuarios con rol `Vendedor`.
- Visualización de productos propios.

#### 🛒 Compra y órdenes
- Crear orden de compra (solo `Compradores`).
- Al comprar: se crea la orden y se descuenta stock.
- Estados de orden: `pendiente`, `enviado`, `recibido`, `cancelada`.
- Solo el `Vendedor` puede marcar como `enviado`.
- Solo el `Comprador` puede marcar como `recibido` o `cancelada` si aún está `pendiente`.
- Cancelación requiere consentimiento mutuo.

#### ⭐ Reputación bidireccional
- Cuando la orden esté `recibida`, ambas partes pueden calificar:
  - El `Comprador` califica al `Vendedor`.
  - El `Vendedor` califica al `Comprador`.
- Calificación: entero del 1 al 5.
- Solo una calificación por parte y por orden.
- Reputación acumulada pública:
  - `reputacion_como_comprador`
  - `reputacion_como_vendedor`

---

## [Contrato 2 – `ReportesView` (solo lectura)](https://github.com/simon1494/ReportView)

### Funcionalidades
- Consultar top 5 vendedores con mejor reputación.
- Consultar top 5 compradores con mejor reputación.
- Ver productos más vendidos.
- Estadísticas por categoría: total de ventas, calificación promedio.
- Cantidad de órdenes por usuario.

**Nota:** este contrato solo puede leer datos del contrato 1. No puede emitir calificaciones, modificar órdenes ni publicar productos.

---

## 📊 Requisitos generales

- ✅ Cobertura de tests ≥ 85% entre ambos contratos.
- ✅ Tests deben contemplar:
  - Flujos completos de compra y calificación.
  - Validaciones y errores esperados.
  - Permisos por rol.
- ✅ Código comentado y bien estructurado.


---

## 🔺 Entrega Mínima – 18 de julio

Incluye:
- Contrato 1 con:
  - Registro de usuarios.
  - Publicación de productos.
  - Compra de productos.
  - Gestión básica de órdenes (`pendiente`, `enviado`, `recibido`).
  - Todo documentado segun lo visto en clase de como documentar en Rust
  - Tests con cobertura ≥ 85%.
  - Address del contrato desplegado en Shibuya Testnet.


---

## 🌟 Entrega Final – Fin de año

Incluye:
- Toda la funcionalidad de ambos contratos.
- Reputación completa bidireccional.
- Reportes por lectura (contrato 2).
- Tests con cobertura ≥ 85%.
- Documentación técnica clara.

### Bonus (hasta +20%):
- Sistema de disputas.
- Simulación de pagos.

---

## 📚 Documentación Técnica del Sistema

### 🎯 Descripción del Proyecto

**RustMarket** es un marketplace descentralizado implementado como un contrato inteligente en Substrate usando el framework Ink!. El sistema permite a los usuarios registrarse con diferentes roles, publicar productos, crear órdenes de compra, gestionar el ciclo de vida de las transacciones y establecer un sistema de reputación bidireccional entre compradores y vendedores.

El contrato está diseñado siguiendo principios de programación modular, separación de responsabilidades y validación estricta de permisos basada en roles.

---

### 🏗️ Arquitectura del Sistema

#### **Estructura Modular mediante Traits**

El sistema implementa una arquitectura basada en traits para separar responsabilidades y facilitar el mantenimiento:

```rust
pub trait GestionProducto { }     // Operaciones de productos
pub trait GestionUsuario { }      // Operaciones de usuarios
pub trait GestionOrden { }        // Operaciones de órdenes
pub trait GestionPublicacion { }  // Operaciones de publicaciones
pub trait GestionCategoria { }    // Operaciones de categorías
pub trait ControlStock { }        // Control de inventario
```

**¿Por qué usar traits?**

1. **Separación de Responsabilidades**: Cada trait agrupa funcionalidades relacionadas, facilitando la localización y modificación de código.

2. **Reutilización**: El trait `ControlStock` se implementa tanto para `Producto` como para `Publicacion`, permitiendo reutilizar la misma lógica de gestión de inventario.

3. **Testing**: Los traits facilitan la creación de mocks y tests unitarios aislados.

4. **Escalabilidad**: Nuevas funcionalidades se pueden agregar implementando nuevos traits sin modificar la estructura base.

5. **Documentación Clara**: Los traits actúan como contratos que definen explícitamente qué operaciones están disponibles.

#### **Estructura Principal del Contrato**

```rust
#[ink(storage)]
pub struct Sistema {
    m_usuarios: Mapping<AccountId, Usuario>,      // Búsqueda rápida O(1)
    v_usuarios: StorageVec<AccountId>,            // Iteración ordenada
    productos: StorageVec<Producto>,              // Productos registrados
    ordenes: StorageVec<Orden>,                   // Historial de órdenes
    publicaciones: StorageVec<Publicacion>,       // Ofertas de productos
    categorias: StorageVec<Categoria>,            // Clasificación
}
```

**Decisiones de diseño:**

- **Mapping + Vec para usuarios**: El `Mapping` permite búsquedas O(1) por AccountId, mientras que el `StorageVec` permite listar todos los usuarios.
- **StorageVec para entidades**: Permite acceso por índice y mantiene el orden de creación.
- **Inmutabilidad de IDs**: Los IDs se asignan secuencialmente basados en la posición en el vector.

---

### 🔑 Entidades del Sistema

#### **Rol**
```rust
pub enum Rol {
    Comprador,  // Puede crear órdenes de compra
    Vendedor,   // Puede crear productos y publicaciones
    Ambos,      // Asignación simultánea de ambos roles
}
```

#### **Usuario**
- Identificado por `AccountId` único
- Nombre y correo electrónico únicos
- Sistema de rating dual (como comprador y como vendedor)
- Lista de roles asignados

#### **Producto**
- Creado por vendedores
- Asociado a una categoría
- Stock global del vendedor
- Se descuenta al crear publicaciones

#### **Publicacion**
- Vincula un producto con precio y stock específicos
- Estado activo/inactivo automático según disponibilidad
- El stock se descuenta al crear órdenes

#### **Orden**
Estados del ciclo de vida:
```
Pendiente → Enviada → Recibida
    ↓
PreCancelada → Cancelada
```

- **Pendiente**: Orden creada, esperando envío
- **Enviada**: Vendedor marcó el envío
- **Recibida**: Comprador confirmó recepción (habilita calificaciones)
- **PreCancelada**: Comprador solicitó cancelación
- **Cancelada**: Vendedor confirmó, stock devuelto

#### **Rating**
Sistema dual de calificaciones:
- `calificacion_comprador`: (suma_puntos, cantidad_calificaciones)
- `calificacion_vendedor`: (suma_puntos, cantidad_calificaciones)
- Promedio calculado automáticamente en formato "X.Y"

---

### 🔐 Interfaz Pública del Contrato

#### **Gestión de Usuarios**

```rust
// Registra un nuevo usuario con nombre, email y rol inicial
#[ink(message)]
pub fn registrar_usuario(&mut self, nombre: String, mail: String, rol: Rol) 
    -> Result<String, ErroresContrato>

// Asigna un rol adicional al caller
#[ink(message)]
pub fn asignar_rol(&mut self, rol: Rol) 
    -> Result<String, ErroresContrato>

// Lista todos los usuarios registrados
#[ink(message)]
pub fn listar_usuarios(&self) -> Vec<Usuario>
```

#### **Gestión de Productos**

```rust
// Crea un producto (solo Vendedor)
#[ink(message)]
pub fn crear_producto(
    &mut self,
    nombre: String,
    descripcion: String,
    categoria: String,
    stock: u32
) -> Result<u32, ErroresContrato>

// Lista todos los productos
#[ink(message)]
pub fn listar_productos(&self) -> Vec<Producto>
```

#### **Gestión de Publicaciones**

```rust
// Crea una publicación de un producto (solo Vendedor)
#[ink(message)]
pub fn crear_publicacion(
    &mut self,
    id_producto: u32,
    stock: u32,
    precio: Balance
) -> Result<u32, ErroresContrato>

// Lista todas las publicaciones
#[ink(message)]
pub fn listar_publicaciones(&self) -> Vec<Publicacion>

// Lista publicaciones del caller (solo Vendedor)
#[ink(message)]
pub fn listar_publicaciones_propias() 
    -> Result<Vec<Publicacion>, ErroresContrato>
```

#### **Gestión de Órdenes**

```rust
// Crea una orden de compra (solo Comprador)
#[ink(message)]
pub fn crear_orden(&mut self, id_publicacion: u32, cantidad: u32) 
    -> Result<u32, ErroresContrato>

// Marca orden como enviada (solo Vendedor de la orden)
#[ink(message)]
pub fn enviar_producto(&mut self, id_orden: u32) 
    -> Result<String, ErroresContrato>

// Marca orden como recibida (solo Comprador de la orden)
#[ink(message)]
pub fn recibir_producto(&mut self, id_orden: u32) 
    -> Result<String, ErroresContrato>

// Cancela una orden (requiere consenso)
#[ink(message)]
pub fn cancelar_orden(&mut self, id_orden: u32) 
    -> Result<String, ErroresContrato>

// Califica la transacción (solo en estado Recibida)
#[ink(message)]
pub fn calificar_compra(&mut self, id_orden: u32, puntaje: u8) 
    -> Result<String, ErroresContrato>

// Lista todas las órdenes
#[ink(message)]
pub fn listar_ordenes(&self) -> Vec<Orden>
```

#### **Gestión de Categorías**

```rust
// Registra una nueva categoría
#[ink(message)]
pub fn registrar_categoria(&mut self, nombre: String) 
    -> Result<String, ErroresContrato>

// Lista todas las categorías
#[ink(message)]
pub fn listar_categorias(&self) -> Vec<Categoria>
```

---

### 👥 Acciones por Rol

#### **Usuario sin Registro**
- ❌ No puede realizar ninguna acción
- ℹ️ Debe registrarse primero usando `registrar_usuario()`

#### **Usuario Registrado (sin roles específicos)**
- ✅ Ver productos, publicaciones y categorías
- ✅ Asignarse roles adicionales
- ❌ No puede crear productos, publicaciones u órdenes

#### **Comprador** (`Rol::Comprador`)
- ✅ Crear órdenes de compra
- ✅ Recibir productos (confirmar recepción)
- ✅ Calificar vendedores (después de recibir)
- ✅ Iniciar cancelación de órdenes pendientes
- ❌ No puede crear productos ni publicaciones
- ❌ No puede enviar órdenes

#### **Vendedor** (`Rol::Vendedor`)
- ✅ Crear productos y categorías
- ✅ Crear publicaciones con precio y stock
- ✅ Enviar productos (marcar orden como enviada)
- ✅ Calificar compradores (después de que reciban)
- ✅ Confirmar cancelaciones iniciadas por compradores
- ✅ Ver sus propias publicaciones
- ❌ No puede crear órdenes de compra
- ❌ No puede recibir productos (solo comprador)

#### **Ambos Roles** (`Rol::Ambos` o tener ambos asignados)
- ✅ Todas las acciones de Comprador
- ✅ Todas las acciones de Vendedor
- ℹ️ En una orden específica, solo actúa según su rol en esa transacción

---

### ⚖️ Validaciones de Lógica de Negocio

#### **Registro de Usuarios**
- ✅ Nombre no puede estar vacío
- ✅ Email no puede estar vacío
- ✅ Nombre debe ser único
- ✅ Email debe ser único
- ✅ AccountId debe ser único

#### **Creación de Productos**
- ✅ Solo usuarios con rol `Vendedor`
- ✅ Nombre no puede estar vacío
- ✅ Descripción no puede estar vacía
- ✅ Stock debe ser mayor a 0
- ✅ Categoría debe existir
- ✅ No pueden existir productos duplicados (mismo nombre y categoría)

#### **Creación de Publicaciones**
- ✅ Solo usuarios con rol `Vendedor`
- ✅ Producto debe existir
- ✅ Stock solicitado debe estar disponible en el producto
- ✅ Stock debe ser mayor a 0
- ✅ Precio debe ser mayor a 0
- ✅ Se descuenta stock del producto automáticamente

#### **Creación de Órdenes**
- ✅ Solo usuarios con rol `Comprador`
- ✅ Publicación debe existir
- ✅ Stock solicitado debe estar disponible en la publicación
- ✅ Cantidad debe ser mayor a 0
- ✅ Vendedor debe mantener el rol `Vendedor`
- ✅ Se descuenta stock de la publicación
- ✅ Si stock llega a 0, publicación se marca como inactiva

#### **Envío de Producto**
- ✅ Solo el vendedor original de la orden
- ✅ Vendedor debe tener rol `Vendedor`
- ✅ Orden debe existir
- ✅ Orden debe estar en estado `Pendiente`
- ❌ No puede enviar si ya fue enviada, recibida o cancelada

#### **Recepción de Producto**
- ✅ Solo el comprador original de la orden
- ✅ Comprador debe tener rol `Comprador`
- ✅ Orden debe existir
- ✅ Orden debe estar en estado `Enviada`
- ❌ No puede recibir si no fue enviada o ya fue recibida/cancelada

#### **Cancelación de Órdenes (Consenso Bidireccional)**

**Fase 1 - Comprador inicia:**
- ✅ Solo el comprador original
- ✅ Orden en estado `Pendiente`
- ✅ Cambia a estado `PreCancelada`
- ℹ️ Stock NO se devuelve aún

**Fase 2 - Vendedor confirma:**
- ✅ Solo el vendedor original
- ✅ Orden en estado `PreCancelada`
- ✅ Cambia a estado `Cancelada`
- ✅ Stock se devuelve a la publicación
- ✅ Publicación se reactiva automáticamente

**Restricciones:**
- ❌ No se puede cancelar si está `Enviada`
- ❌ No se puede cancelar si está `Recibida`
- ❌ Vendedor no puede cancelar sin que comprador inicie
- ❌ No se puede cancelar dos veces

#### **Calificaciones**
- ✅ Orden debe estar en estado `Recibida`
- ✅ Puntaje debe ser entre 1 y 5
- ✅ Comprador califica al vendedor
- ✅ Vendedor califica al comprador
- ✅ Solo una calificación por rol por orden
- ✅ Usuario debe ser parte de la orden (comprador o vendedor)
- ❌ No puede calificar dos veces con el mismo rol
- ❌ No puede calificar si no es parte de la orden

#### **Categorías**
- ✅ Nombre se normaliza (minúsculas, sin espacios extra)
- ✅ Máximo 100 caracteres
- ✅ No puede estar vacío después de normalizar
- ✅ No pueden existir categorías duplicadas (después de normalizar)

---

### 🔄 Flujos Completos del Sistema

#### **Flujo 1: Registro y Asignación de Roles**

```
1. Usuario → registrar_usuario(nombre, email, Rol::Comprador)
2. Sistema valida unicidad de nombre y email
3. Sistema crea Usuario con rol Comprador
4. Usuario → asignar_rol(Rol::Vendedor)
5. Sistema agrega Vendedor a la lista de roles
6. Usuario ahora tiene ambos roles
```

#### **Flujo 2: Publicación de Producto**

```
1. Vendedor → registrar_categoria("Electrónica")
2. Sistema crea categoría normalizada
3. Vendedor → crear_producto("Laptop", "Gaming", "Electrónica", 10)
4. Sistema valida rol Vendedor
5. Sistema crea Producto con ID=0, stock=10
6. Vendedor → crear_publicacion(id_producto=0, stock=5, precio=1000)
7. Sistema descuenta 5 del stock del producto (queda 5)
8. Sistema crea Publicacion con ID=0, activa=true
```

#### **Flujo 3: Compra Exitosa con Calificación**

```
1. Comprador → crear_orden(id_publicacion=0, cantidad=2)
2. Sistema valida rol Comprador y stock
3. Sistema descuenta 2 de publicación (queda 3)
4. Sistema crea Orden ID=0, estado=Pendiente
5. Vendedor → enviar_producto(id_orden=0)
6. Sistema valida que es el vendedor original
7. Sistema cambia estado a Enviada
8. Comprador → recibir_producto(id_orden=0)
9. Sistema valida que es el comprador original
10. Sistema cambia estado a Recibida
11. Comprador → calificar_compra(id_orden=0, puntaje=5)
12. Sistema registra calificación del vendedor
13. Sistema actualiza rating del vendedor
14. Vendedor → calificar_compra(id_orden=0, puntaje=4)
15. Sistema registra calificación del comprador
16. Sistema actualiza rating del comprador
```

#### **Flujo 4: Cancelación con Consenso**

```
1. Comprador → crear_orden(id_publicacion=0, cantidad=2)
2. Sistema crea Orden, estado=Pendiente
3. Sistema descuenta stock de publicación
4. Comprador → cancelar_orden(id_orden=0)
5. Sistema valida que es el comprador
6. Sistema cambia estado a PreCancelada
7. Stock NO se devuelve aún
8. Vendedor → cancelar_orden(id_orden=0)
9. Sistema valida que es el vendedor
10. Sistema cambia estado a Cancelada
11. Sistema devuelve 2 unidades a la publicación
12. Sistema reactiva publicación (activa=true)
```


---

### 📊 Manejo de Errores

El sistema utiliza un enum `ErroresContrato` exhaustivo con más de 60 variantes que cubren todos los casos de error posibles:

```rust
pub enum ErroresContrato {
    // Validación de datos
    DatosInvalidos,
    PrecioInvalido,
    StockInvalido,
    
    // Permisos
    RolNoApropiado,
    NoEsVendedorOriginal,
    NoEsCompradorOriginal,
    
    // Estados
    OrdenNoPendiente,
    OrdenNoEnviada,
    OrdenYaCancelada,
    
    // Existencia
    UsuarioNoExiste,
    ProductoInexistente,
    OrdenInexistente,
    
    // ... y muchos más
}
```

Cada operación retorna `Result<T, ErroresContrato>`, permitiendo manejo explícito de errores.

---

### 🧪 Testing

El proyecto incluye más de 100 tests unitarios que cubren:

- ✅ Flujos completos de compra-venta
- ✅ Validaciones de roles y permisos
- ✅ Estados de órdenes y transiciones
- ✅ Sistema de calificaciones
- ✅ Cancelaciones con consenso
- ✅ Gestión de stock e inventario
- ✅ Casos límite y errores esperados
- ✅ Getters y setters de encapsulación

**Cobertura:** ≥ 85% del código

---

### 🚀 Nota final

Este contrato sirve como base para el **Contrato 2 - ReportesView**, que consumirá los datos públicos para generar:
- Rankings de vendedores y compradores
- Estadísticas de ventas por categoría
- Productos más vendidos
- Métricas de actividad del marketplace

---

