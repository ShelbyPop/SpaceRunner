from PIL import Image

def generate_verilog(image_path):
    img = Image.open(image_path).convert('RGB')
    width, height = img.size

    print("// Generated Data for 32x32 Textures")
    index = 0
    for y in range(height):
        for x in range(width):
            r, g, b = img.getpixel((x, y))
            # Convert 8-bit to 4-bit color
            r = r >> 4
            g = g >> 4
            b = b >> 4
            hex_val = (g << 8) | (b << 4) | r
            print(f"rom[{index}] = 12'h{hex_val:03X};")
            index += 1

generate_verilog("Tileset2.png")