"""Base64 helpers."""

from base64 import b64encode

class FilterModule(object):
    def filters(self):
        return {
            'base64': self.base64,
            'base64_values': self.base64_values
        }
    def base64_values(self, d):
        return dict((k, self.base64(v))
                    for k, v in d.items())

    def base64(self, v):
        return b64encode(pry_out_bytes(v)).decode("ascii")

def pry_out_bytes(soi_disant_unicode_string_a_la_Python):
    """YA RLY.

    https://stackoverflow.com/a/27367173/435004
    """
    return soi_disant_unicode_string_a_la_Python.encode(
        'utf-8', 'surrogateescape')
