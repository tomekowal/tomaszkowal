defmodule TomaszkowalWeb.KeybaseController do
  use TomaszkowalWeb, :controller

  @keybase_proof """
  ==================================================================
  https://keybase.io/tomekowal
  --------------------------------------------------------------------

  I hereby claim:

    * I am an admin of https://www.tomaszkowal.com
    * I am tomekowal (https://keybase.io/tomekowal) on keybase.
    * I have a public key ASCQfJXGt6KTkHvnKuAsQRJaFfq3_yQ8EjtdvUtoi7z7WQo

  To do so, I am signing this object:

  {
    "body": {
      "key": {
        "eldest_kid": "0120a4ef4e6f5e066c9ec2dd78635c447fc935b0db157c0629c93578e1dc51b1eb4a0a",
        "host": "keybase.io",
        "kid": "0120907c95c6b7a293907be72ae02c41125a15fab7ff243c123b5dbd4b688bbcfb590a",
        "uid": "2b585a9e2287e380c242e0e2383afe19",
        "username": "tomekowal"
      },
      "merkle_root": {
        "ctime": 1717263014,
        "hash": "ec58ed840469b6869d7bc732802d8ad38446eece621389a52d39dd8843c3564c4457f7bf3c82dbfbc3d84f3cdc15d74ac96b4747293e9b7a59afe0da8b43d2d2",
        "hash_meta": "edc36b2afc220a3672cd9168a9abb7e5ad6840242d82fb1ecc814e99c4ee8d1c",
        "seqno": 25782795
      },
      "service": {
        "entropy": "jx7RDXfU/NiOHSOR9QR2hJX8",
        "hostname": "www.tomaszkowal.com",
        "protocol": "https:"
      },
      "type": "web_service_binding",
      "version": 2
    },
    "client": {
      "name": "keybase.io go client",
      "version": "6.3.0"
    },
    "ctime": 1717263073,
    "expire_in": 504576000,
    "prev": "4a17d9e5d1069b6c2e0e207d4bbeeede4f0c9278c1a647924001b6c5ce4bd377",
    "seqno": 66,
    "tag": "signature"
  }

  which yields the signature:

  hKRib2R5hqhkZXRhY2hlZMOpaGFzaF90eXBlCqNrZXnEIwEgkHyVxreik5B75yrgLEESWhX6t/8kPBI7Xb1LaIu8+1kKp3BheWxvYWTESpcCQsQgShfZ5dEGm2wuDiB9S77u3k8MknjBpkeSQAG2xc5L03fEIAY7+u70ngADggjojjcMYrypsV4/gCTpxYwL3S+VsTfeAgHCo3NpZ8RAiN7HLlgzdU8670gj/qyq4DTKAtAwiaNigI2PxtimXNl+uRSyA89+/I0oOZ80tNdK0UHpVafP9T5E/dvz1kr9BKhzaWdfdHlwZSCkaGFzaIKkdHlwZQildmFsdWXEIL6Zr+2OZmuNpTKxv8R/FO3G0vI1ExdGH2aF4xi5U9Xjo3RhZ80CAqd2ZXJzaW9uAQ==

  And finally, I am proving ownership of this host by posting or
  appending to this document.

  View my publicly-auditable identity here: https://keybase.io/tomekowal

  ==================================================================
  """

  def show(conn, _) do
    text(conn, @keybase_proof)
  end
end
