import random
from PIL import Image, ImageDraw

# ---------------------------------------------------------
# Configuración general
# ---------------------------------------------------------
# Tamaño de una hoja A4 en píxeles a 300 DPI
A4_WIDTH, A4_HEIGHT = 2480, 3508

# Número máximo de objetos que vamos a dibujar
MAX_OBJECTS = 10

# Radios en píxeles para los dos tipos de objetos
TAPITA_RADIUS = 180   # radio para una tapita (~180 px radio)
LENTIL_RADIUS = 60    # radio para una lentil (~60 px radio)

# Colores base para los objetos
BASE_COLORS = {
    'yellow': (255, 255, 0),
    'green':  (0, 200, 0),
    'purple': (128, 0, 128),
    'blue':   (0, 0, 255),
}

# Nombres para los tipos de objeto
TAPITA = "tapita"
LENTIL = "lentil"

# ---------------------------------------------------------
# Función para variar ligeramente el color base
# ---------------------------------------------------------
def randomize_color(base_rgb, max_variation=40):
    """Devuelve un color parecido al base, pero con pequeñas variaciones."""
    r, g, b = base_rgb
    return (
        max(0, min(255, r + random.randint(-max_variation, max_variation))),
        max(0, min(255, g + random.randint(-max_variation, max_variation))),
        max(0, min(255, b + random.randint(-max_variation, max_variation))),
    )

# ---------------------------------------------------------
# Generar lista de objetos con tipo y color
# ---------------------------------------------------------
def generate_objects(max_objects=MAX_OBJECTS):
    """Crea una lista de objetos con color y tipo aleatorio."""
    objs = []
    for i in range(max_objects):
        color_name = random.choice(list(BASE_COLORS.keys()))
        tipo = random.choice([TAPITA, LENTIL])
        color = randomize_color(BASE_COLORS[color_name])
        objs.append({"color": color, "tipo": tipo})
    return objs

# ---------------------------------------------------------
# Comprobar si la nueva posición es válida (no se superpone)
# ---------------------------------------------------------
def is_valid_position(new_pos, placed_positions, radius):
    """Verifica que el nuevo círculo no se superponga con los ya colocados."""
    for (x, y, r) in placed_positions:
        dist = ((new_pos[0]-x)**2 + (new_pos[1]-y)**2)**0.5
        if dist < (r + radius + 10):  # margen extra entre objetos
            return False
    return True

# ---------------------------------------------------------
# Generar posiciones para cada objeto sin que se superpongan
# ---------------------------------------------------------
def generate_positions(objects):
    """Asigna posiciones a los objetos evitando superposiciones."""
    placed = []
    positions = []
    for obj in objects:
        radius = TAPITA_RADIUS if obj['tipo']==TAPITA else LENTIL_RADIUS
        for _ in range(500):  # hasta 500 intentos por objeto
            x = random.randint(radius, A4_WIDTH - radius)
            y = random.randint(radius, A4_HEIGHT - radius)
            if is_valid_position((x, y), placed, radius):
                placed.append((x, y, radius))
                positions.append((x, y))
                break
    return positions

# ---------------------------------------------------------
# Dibujar la imagen en blanco con los objetos
# ---------------------------------------------------------
def draw_image(objects, positions, filename):
    """Crea una imagen PNG con las tapitas y lentils dibujadas."""
    img = Image.new('RGB', (A4_WIDTH, A4_HEIGHT), color='white')
    draw = ImageDraw.Draw(img)
    for obj, pos in zip(objects, positions):
        radius = TAPITA_RADIUS if obj['tipo']==TAPITA else LENTIL_RADIUS
        x, y = pos
        draw.ellipse(
            (x-radius, y-radius, x+radius, y+radius),
            fill=obj['color'],
            outline='black'
        )
    img.save(filename, quality=95)
    print(f"✔ Imagen guardada en: {filename}")

# ---------------------------------------------------------
# Código principal
# ---------------------------------------------------------
if __name__ == "__main__":
    # Generamos la lista de objetos que vamos a dibujar
    objetos = generate_objects(MAX_OBJECTS)

    # Generamos posiciones para la primera imagen
    pos1 = generate_positions(objetos)
    draw_image(objetos, pos1, "imagen1.png")

    # Generamos posiciones para la segunda imagen
    pos2 = generate_positions(objetos)
    draw_image(objetos, pos2, "imagen2.png")
