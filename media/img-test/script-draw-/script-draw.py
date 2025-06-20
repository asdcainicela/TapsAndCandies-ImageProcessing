import random
from PIL import Image, ImageDraw

# Configuración
A4_WIDTH, A4_HEIGHT = 2480, 3508  # A4 a 300 DPI
MAX_OBJECTS = 10
TAPITA_RADIUS = 180   # radio para tapita (~180 px de diámetro)
LENTIL_RADIUS = 60    # radio para lentil (~60 px de radio)

# Colores base en RGB
BASE_COLORS = {
    'yellow': (255, 255, 0),
    'green':  (0, 200, 0),
    'purple': (128, 0, 128),
    'blue':   (0, 0, 255)
}

# Tipo de objeto
TAPITA = "tapita"
LENTIL = "lentil"

# Función para obtener color variado cercano
def randomize_color(base_rgb, max_variation=40):
    r, g, b = base_rgb
    return (
        max(0, min(255, r + random.randint(-max_variation, max_variation))),
        max(0, min(255, g + random.randint(-max_variation, max_variation))),
        max(0, min(255, b + random.randint(-max_variation, max_variation))),
    )

# Generar lista de objetos con tipo y color
def generate_objects(max_objects=MAX_OBJECTS):
    objs = []
    for i in range(max_objects):
        color_name = random.choice(list(BASE_COLORS.keys()))
        tipo = random.choice([TAPITA, LENTIL])
        color = randomize_color(BASE_COLORS[color_name])  # color ligeramente aleatorio
        objs.append({"color": color, "tipo": tipo})
    return objs

# Comprobar si una posición es válida (no superpuesta)
def is_valid_position(new_pos, placed_positions, radius):
    for (x, y, r) in placed_positions:
        dist = ((new_pos[0]-x)**2 + (new_pos[1]-y)**2)**0.5
        if dist < (r + radius + 10):  # margen extra
            return False
    return True

# Generar posiciones sin superponer
def generate_positions(objects):
    placed = []
    positions = []
    for obj in objects:
        radius = TAPITA_RADIUS if obj['tipo']==TAPITA else LENTIL_RADIUS
        for _ in range(500):  # intentos max
            x = random.randint(radius, A4_WIDTH - radius)
            y = random.randint(radius, A4_HEIGHT - radius)
            if is_valid_position((x, y), placed, radius):
                placed.append((x, y, radius))
                positions.append((x, y))
                break
    return positions

# Dibujar imagen
def draw_image(objects, positions, filename):
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
    print(f"✅ Guardada imagen: {filename}")

if __name__ == "__main__":
    # Generar objetos
    objetos = generate_objects(MAX_OBJECTS)

    # Imagen 1
    pos1 = generate_positions(objetos)
    draw_image(objetos, pos1, "imagen1.png")

    # Imagen 2 con mismas cantidades y tipo/color
    pos2 = generate_positions(objetos)
    draw_image(objetos, pos2, "imagen2.png")
