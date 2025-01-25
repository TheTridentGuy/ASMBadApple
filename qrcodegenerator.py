import qrcode
import base64


def qr_from_binary(binary_path):
    with open(binary_path, "rb") as f:
        data = f.read()
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    encoded_data = base64.b64encode(data).decode("ascii")
    qr.add_data("data:application/octet-stream;base64," + encoded_data)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")
    img.save("qr.png")

qr_from_binary("badappletiny")
