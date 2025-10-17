class_name  NonPlaylableCharacter
extends CharacterBody2D

@export var min_walk_cycle: int = 2
@export var max_walk_cycle: int = 6

# --- Properti baru untuk kontrol idle/walk ---
@export var idle_duration_min: float = 3.0 # Durasi idle minimum (detik)
@export var idle_duration_max: float = 7.0 # Durasi idle maksimum (detik)
@export var walk_initiate_chance: float = 0.8 # Probabilitas (0.0 - 1.0) untuk mulai berjalan setelah idle
# --- Akhir properti baru ---

var walk_cycles: int
var current_walk_cycle: int

""" ### CATATAN ###
# Untuk Sapi (Cow):
  - Idle Duration Min: Misalnya, 15.0 (15 detik)
  - Idle Duration Max: Misalnya, 30.0 (30 detik)
  - Walk Initiate Chance: Misalnya, 0.3 (30% kemungkinan untuk mulai berjalan)
Ini akan membuat sapi diam antara 15 hingga 30 detik, dan setelah itu hanya ada 30% kemungkinan ia akan mulai berjalan. Jika tidak, ia akan diam lagi.

# Untuk Ayam (Chicken):
  - Idle Duration Min: Misalnya, 3.0 (3 detik)
  - Idle Duration Max: Misalnya, 7.0 (7 detik)
  - Walk Initiate Chance: Misalnya, 0.8 (80% kemungkinan untuk mulai berjalan)
Ini akan membuat ayam diam lebih singkat (3-7 detik) dan memiliki kemungkinan yang lebih tinggi (80%) untuk mulai berjalan setelah periode idle-nya.
"""
