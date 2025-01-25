import cv2

def convert(input_path):
    image = cv2.imread(input_path)
    image = cv2.resize(image, (8, 8))
    image = cv2.threshold(image, 128, 255, cv2.THRESH_BINARY)[1]
    hex_bytes = []
    for row in image:
        byte = 0
        for i, pixel in enumerate(row):
            if pixel[0] == 0:
                byte |= (1 << (7 - i))
        hex_bytes.append(byte)
    print(",".join(f"0x{byte:02x}" for byte in hex_bytes))


convert("ba5.png")
