# CashFlow Todo — Technical Design Doc (v1)

## Índice

| # | Sección |
|---|---------|
| 1 | [Contexto](#1-contexto) |
| 2 | [Objetivos](#2-objetivos) |
| 3 | [Alcance](#3-alcance) |
| 4 | [Modelo de Dominio](#4-modelo-de-dominio) |
| 5 | [Inputs soportados](#5-inputs-soportados-raw) |
| 6 | [Reglas de validación](#6-reglas-de-validación-v1) |
| 7 | [API pública](#7-api-pública-v1) |
| 8 | [Arquitectura de módulos](#8-arquitectura-de-módulos-propuesta) |
| 9 | [Estrategia de testing](#9-estrategia-de-testing) |
| 10 | [Consideraciones / tradeoffs](#10-consideraciones--tradeoffs) |
| 11 | [Roadmap](#11-roadmap) |
| 12 | [Criterios de éxito](#12-criterios-de-éxito-definition-of-done) |
| 13 | [Playbook de ejercicios](#13-playbook-de-ejercicios) |

---

## 1. Contexto
Necesito un proyecto de onboarding para Elixir que simule un caso real: registrar pagos por realizar y pagos realizados (entradas/salidas) provenientes de distintos proveedores, con formatos de datos inconsistentes (“inputs sucios”), y generar un resumen de flujo de caja en memoria.

Este proyecto está diseñado para ejercitar:
- tipos de datos (integer/float/string/atom/map)
- casting/parsing
- operadores aritméticos y comparaciones
- pattern matching
- control structures (`case`, `cond`, `with`)
- funciones con múltiples cabezas + guards
- structs (dominio)
- pruebas con ExUnit

---

## 2. Objetivos

### Objetivos funcionales (MVP)
1. Crear un ledger en memoria.
2. Agregar pagos con inputs sucios y normalizarlos.
3. Marcar pagos como pagados.
4. Consultar listas: pendientes / pagados.
5. Generar summary de flujo de caja:
   - total entradas (in)
   - total salidas (out)
   - neto (in - out)

### Objetivos no funcionales
- API consistente: `{:ok, value}` / `{:error, %Error{...}}`
- Reglas de validación explícitas
- Código modular, testeable, extensible
- Sin dependencias externas innecesarias

---

## 3. Alcance

### In scope (v1)
- Ledger in-memory
- Parsing robusto de montos con símbolos: `$`, `#`, comas, espacios
- Dirección: entra/sale + aliases (`in/out`, español/inglés)
- Status: pending/paid + aliases (pendiente/pagado/realizado)
- Tests unitarios para parser y flujo principal

### Out of scope (v1)
- Persistencia (DB/archivos)
- UI (Phoenix/LiveView)
- Concurrencia y estado compartido (GenServer)
- Multi-currency, impuestos, descuentos, facturación
- Control de acceso / auth

---

## 4. Modelo de Dominio

### Payment (normalizado)
Representa un movimiento de caja.

**Campos:**
- `id :: String.t()` (generado internamente)
- `vendor :: String.t()` (proveedor o cliente)
- `amount_cents :: non_neg_integer()` (monto en centavos, int)
- `direction :: :in | :out`
- `status :: :paid`
- `inserted_at :: DateTime.t()`

**Rationale:**
Usar `amount_cents` evita problemas con floats; es práctica común en sistemas financieros.

### Ledger (in-memory)
- `payments :: list(Payment.t())`

### Error (consistente)
- `code :: atom()`
- `message :: String.t()`
- `field :: atom() | nil`
- `input :: any()`

---

## 5. Inputs soportados (raw)
Se aceptará un `map()` con keys atom o string:

**Ejemplos válidos:**
```elixir
%{vendor: "CFE", amount: "$123.30", direction: "sale", status: "pending"}
%{"vendor" => "AWS", "amount" => "#1,234.50", "direction" => "entra", "status" => "paid"}
%{vendor: "Telmex", amount: 123.30, direction: :out, status: :pending}
```

---

## 6. Reglas de validación (v1)

| Campo      | Reglas | Errores           |
|-----------|--------|-------------------|
| `vendor`  | Requerido, string no vacío (trim) | `:invalid_vendor` |
| `amount`  | Soporta integer, float, string. Debe ser >= 0. Strings pueden traer: `$`, `#`, comas, espacios. Convertir a `amount_cents` | `:invalid_amount` |
| `direction` | Acepta `:in` \| `:out`. Strings: entra, in, entrada, ingreso, income → `:in`; sale, out, salida, egreso, expense → `:out` | `:invalid_direction` |
| `status`  | Acepta `:pending` \| `:paid`. Strings: pending, pendiente → `:pending`; paid, pagado, realizado → `:paid` | `:invalid_status` |

---

## 7. API pública (v1)

| Operación        | Función | Firma |
|-----------------|---------|-------|
| Crear ledger    | `CashFlow.new_ledger/0` | `Ledger.t()` |
| Agregar pago    | `CashFlow.add_payment/2` | `{:ok, Ledger.t()} \| {:error, Error.t()}` |
| Marcar pagado   | `CashFlow.mark_paid/2` | `{:ok, Ledger.t()} \| {:error, Error.t()}` |
| Listar pendientes | `CashFlow.pending/1` | `list(Payment.t())` |
| Listar pagados  | `CashFlow.paid/1` | `list(Payment.t())` |
| Resumen         | `CashFlow.summary/1` | `%{in_cents: integer, out_cents: integer, net_cents: integer}` |

---

## 8. Arquitectura de módulos (propuesta)

```
lib/cash_flow/
  cash_flow.ex      # API pública y orquestación
  ledger.ex         # struct + helpers de estado
  payment.ex        # struct de dominio
  parser.ex         # parse_amount/parse_direction/parse_status
  error.ex          # struct y helper Error.new/4

test/cash_flow/
  parser_test.exs
  cash_flow_test.exs
```

**Separar Parser del flujo principal permite:**
- Tests aislados
- Reemplazar reglas sin tocar engine
- Practicar pattern matching y control structures en un módulo dedicado

---

## 9. Estrategia de testing

**Parser**
- Casos válidos: `$123.30`, `#123.30`, `1,234.50`, `" 123.3 "`
- Inválidos: `"abc"`, `""`, `nil`, `-1`, `-1.0`
- `direction` / `status` con variantes y mayúsculas

**Engine**
- `add_payment` + `summary`
- `mark_paid` cambia status
- `pending` / `paid` filtran correctamente
- Error cuando falta `vendor` o `amount`

---

## 10. Consideraciones / tradeoffs

| Tema | Decisión |
|------|----------|
| **Dinero en centavos (int) vs float** | Elegimos `amount_cents` (int) por consistencia y precisión. En v2 podría migrarse a Decimal. |
| **Estado in-memory** | MVP usa Ledger puro (inmutable) para aprender Elixir core. V2: LedgerServer con GenServer y Supervisor. |
| **IDs** | `:crypto` + `Base.encode16`. V2: uuid real si se añade dependencia. |

---

## 11. Roadmap

| Versión | Alcance |
|---------|---------|
| **v1 (MVP)** | Parser + Engine in-memory + tests |
| **v1.1** | `totals_by_vendor/1`, `filter_by_vendor/2`, `list_recent/2` |
| **v2 (OTP)** | CashFlow.LedgerServer (GenServer), Supervisor, tests de restart |
| **v3 (persistencia)** | Ecto schema + Repo (Postgres), migraciones, (opcional) Phoenix UI |

---

## 12. Criterios de éxito (Definition of Done)

- [ ] `mix test` pasa
- [ ] Parser cubre formatos sucios principales
- [ ] API pública devuelve tuplas `{:ok, _}` / `{:error, _}` consistentes
- [ ] Código con módulos separados y documentación básica
- [ ] README con "cómo correr" + ejemplos de IEx

---

## 13. Playbook de ejercicios

Ejercicios de práctica para Elixir: pattern matching, guards, estructuras de control y dominios cercanos al CashFlow.

### Cómo ejecutar

```bash
# Ejecutar un script individual
mix run playbook/01_patterns_demo.exs

# O desde IEx
iex -S mix
iex> Code.eval_file("playbook/01_patterns_demo.exs")
```

### Índice de ejercicios

| # | Script | Módulo | Concepto | Descripción |
|---|--------|--------|----------|-------------|
| 01 | `01_patterns_demo.exs` | `Exercises.Patterns` | Pattern matching en tuplas | Área de figuras (rectángulo, círculo, cuadrado) con múltiples cabezas |
| 02 | `02_patterns_atoms.exs` | `Exercises.PatternsAtoms` | Atoms + pattern matching | Normalización de direcciones (`:in`/`:out`) con strings y atoms |
| 03 | `03_number_classificartos_guards.ex` | `Exercises.NumberClassificator` | Guards | Clasificación de números: positive / negative / zero |
| 04 | `04_secure_calculator_tuples.exs` | `Exercises.SecureCalculator` | Tuplas ok/error | Calculadora con operaciones y manejo de operación inválida |
| 05 | `05_recursive_sum.exs` | `Exercises.RecursiveSum` | Recursión | Suma recursiva de listas |
| 06 | `06_pattern_maps.exs` | `Exercises.PatternMaps` | Pattern matching en maps | Filtrado de pagos por `status: :pending` |
| 07 | `07_manual_reducer.exs` | `Exercises.ManualReducer` | Reduce manual | Implementación de `reduce/3` sin Enum |
| 08 | `08_vendor_group.exs` | `Exercises.VendorGroup` | Agrupación por clave | Agrupar pagos por vendor y sumar montos |
| 09 | `09_state_machine.exs` | `Exercises.StateMachine` | Máquina de estados | Transiciones: pending → approved/rejected, reset |
| 10 | `10_validation_with.exs` | `Exercises.ValidationWith` | `with` para validación | Validar vendor, amount, direction con early return |
| 11 | `11_engine.exs` | `CashFlow.Engine` | Ledger in-memory | new_ledger, add_payment (input sucio/limpio), pending, paid, summary, errores |

### Estructura de módulos

```
lib/exercises/
  basic_parser.ex              # Parser de montos (ejercicio pendiente)
  manual_reducer.ex            # reduce/3 manual
  number_classificator.ex      # classify/1 con guards
  pattern_maps.ex              # pending/1 para listas de maps
  patterns_atoms.ex            # Normalización direction
  patterns_matching_functions.ex  # Área de figuras (alias Patterns)
  recursive_sum.ex             # sum/1 recursivo
  secure_calculator.ex         # calculate/3 con tuplas
  state_machine.ex             # transition/2
  validation_with.ex          # validate/1 con with
  vendor_group.ex              # group_by_vendor/1
```