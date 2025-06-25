#!/bin/bash

# -----------------------------------------------------------------------------
# Skrypt: bootstrap-certs.bash
#
# Opis:
#   Skrypt pobiera wszystkie certyfikaty CA z backendu Vault PKI (domyślnie pki-root-ca)
#   Umożliwia to wygodne zebranie całego łańcucha certyfikatów CA dla domeny rachuna-net.pl.
#
# Wymagania:
#   - Zmienna środowiskowa VAULT_ADDR musi być ustawiona na adres serwera Vault.
#   - Zmienna środowiskowa VAULT_TOKEN musi być ustawiona na ważny token Vault.
#   - Narzędzie jq musi być zainstalowane w systemie.
#
# Działanie:
#   1. Pobiera listę seriali certyfikatów z Vault.
#   2. Dla każdego serialu pobiera certyfikat i zapisuje go do katalogu
#      /usr/local/share/ca-certificates.
# -

PKI_PATH="pki-root-ca"
OUTPUT_PATH="/usr/local/share/ca-certificates/bundle-ca.crt"
echo -e ""

echo -e "\033[1;33m===>\033[0m Pobieranie CA certyfikatu dla rachuna-net.pl"

if [[ -z "$VAULT_ADDR" ]]; then
  echo "❌ Błąd: VAULT_ADDR nie jest ustawione"
  exit 1
fi

if [[ -z "$VAULT_TOKEN" ]]; then
  echo "❌ Błąd: VAULT_TOKEN nie jest ustawione"
  exit 1
fi

# Sprawdź, czy jq jest zainstalowane
if ! command -v jq &> /dev/null; then
  echo "❌ Błąd: jq nie jest zainstalowane. Zainstaluj jq, aby kontynuować."
  exit 1
fi

serials=$CA_SERIALS

> "bundle-ca.crt"

for serial in $serials; do
  echo -e ""
  echo "Pobieranie certyfikatu dla serialu: $serial"
  cert=$(curl -s -k -H "X-Vault-Token: $VAULT_TOKEN" "$VAULT_ADDR/v1/$PKI_PATH/cert/$serial" | jq -r '.data.certificate')
  echo "$cert" >> "bundle-ca.crt"
  echo "✅ Zapisano certyfikat"
done

echo -e ""
sudo mv "bundle-ca.crt" "$OUTPUT_PATH"
sudo update-ca-certificates
echo -e ""
echo "✅ Zaktualizowano certyfikaty systemowe"
echo -e ""