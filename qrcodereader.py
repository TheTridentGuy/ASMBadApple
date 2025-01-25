from qreader import QReader
import cv2
import base64


# Create a QReader instance
qreader = QReader()

# Get the image that contains the QR code
image = cv2.cvtColor(cv2.imread("qr.png"), cv2.COLOR_BGR2RGB)

# Use the detect_and_decode function to get the decoded QR data
decoded_text = qreader.detect_and_decode(image=image)[0]
decoded_text = decoded_text.split(",")[1]
print(decoded_text)
decoded_text = decoded_text.encode("ascii")
decoded_text = base64.b64decode(decoded_text)
with open("binfromqr", "wb") as f:
    f.write(decoded_text)