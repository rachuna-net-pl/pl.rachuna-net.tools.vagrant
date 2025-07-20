# <img src=".gitlab/avatar.png" alt="vagrant" height="20"/> Vagrant

[![](https://gitlab.com/pl.rachuna-net/tools/vagrant/-/badges/release.svg)](https://gitlab.com/pl.rachuna-net/tools/vagrant/-/releases)
[![](https://gitlab.com/pl.rachuna-net/tools/vagrant/badges/main/pipeline.svg)](https://gitlab.com/pl.rachuna-net/tools/vagrant/-/commits/main)

Konfiguracja środowiska deweloperskiego z użyciem Vagrant i VirtualBox.

> [!tip]
> Ten projekt udostępnia środowisko wirtualne oparte na Vagrant, skonfigurowane do uruchomienia maszyny wirtualnej z Ubuntu 42.04 z niezbędnymi narzędziami i skryptami provisioningowymi dostosowanymi do infrastruktury rachuna-net.

## Wymagania wstępne

- [VirtualBox](https://www.virtualbox.org/) (lub inny wspierany provider Vagrant)
- [Vagrant](https://www.vagrantup.com/)

---
## Zmienne środowiskowe

Konfigurację maszyny wirtualnej można dostosować za pomocą zmiennych środowiskowych:

| Zmienna                    | Domyślna wartość         | Opis                                          |
|----------------------------|--------------------------|-----------------------------------------------|
| `VAGRANT_HOSTNAME`         | `dev-station`            | Nazwa hosta maszyny wirtualnej                |
| `VAGRANT_VM_MEMORY`        | `4096` (MB)              | Ilość pamięci RAM przydzielonej maszynie      |
| `VAGRANT_NUM_CPUS`         | `4`                      | Liczba rdzeni CPU przydzielonych maszynie     |
| `VAGRANT_VM_BASE_IMAGE`    | `alvistack/ubuntu-24.04` | Obraz bazowy maszyny wirtualnej               |
| `VAGRANT_REPOSITORIES_DIR` | `/repo`                  | Katalog na hoście synchronizowany do VM       |

---
## Synchronizowane katalogi

- Aktualny katalog projektu jest synchronizowany do `/vagrant` w maszynie wirtualnej.
- Katalog repozytoriów na hoście (domyślnie `/repo`) jest synchronizowany do tej samej ścieżki w VM.
- Katalog `userfiles` jest synchronizowany do `/tmp/userfiles` w VM i kopiowany do katalogu domowego użytkownika podczas provisioning.

> [!tip]
> katalog `repo` jest katalogiem, w którym znajdują się repozytoria
> katalog `userfiles` jest katalogiem, w którym znajdują się pliki użytkownika


---
## Provisioning

Provisioning jest realizowany przez skrypt `bootstrap.bash`, który uruchamia się automatycznie przy starcie VM. Wykonuje on:

1. Kopiuje pliki konfiguracyjne użytkownika z katalogu `userfiles/` do katalogu domowego użytkownika VM.
2. Wykonuje listę skryptów provisioningowych zdefiniowanych w pliku `scripts_to_run`.

### Skrypty provisioningowe

- `provisioning/upgrade-ubuntu.bash`  
  Aktualizuje listę pakietów systemowych, instaluje dostępne aktualizacje oraz wykonuje aktualizację dystrybucji.

- `provisioning/bootstrap-certs.bash`  
  Pobiera certyfikaty CA z backendu Vault PKI i aktualizuje zaufane certyfikaty systemowe.  
  **Wymaga ustawienia zmiennych środowiskowych:**  
  - `VAULT_ADDR` (adres serwera Vault)  
  - `VAULT_TOKEN` (token uwierzytelniający Vault)  
  - `CA_SERIALS` (lista numerów seryjnych certyfikatów do pobrania)

- `provisioning/install-packages.bash`  
  Instaluje niezbędne pakiety, w tym narzędzia do budowy, curl, git, jq, podman, Python 3, narzędzia gościa VirtualBox, zsh i inne.  
  Dodatkowo instaluje [oh-my-zsh](https://ohmyz.sh/) oraz narzędzie CLI GitLab `glab`.

- `provisioning/install-hashicorp.bash`  
  Dodaje repozytorium Hashicorp i instaluje narzędzia Hashicorp: Consul, Packer, Terraform oraz Vault.  
  Usługi Consul i Vault są domyślnie wyłączone.


---
## Uruchamianie maszyny wirtualnej

Maszynę można uruchomić za pomocą dostarczonych skryptów lub ręcznie poleceniami Vagrant:

- Na Linux/macOS:

  ```bash
  ./start_vm.bash
  ```

- Na Windows (PowerShell lub CMD):

  ```cmd
  start_vm.bat
  ```

- Lub ręcznie:

  ```bash
  vagrant up
  ```

Maszyna zostanie skonfigurowana zgodnie z powyższymi zmiennymi środowiskowymi.

---
## Dostęp do maszyny wirtualnej

- SSH jest dostępne na porcie `2222` na hoście, przekierowanym do portu `22` w VM.
- Połączenie można nawiązać poleceniem:

  ```bash
  ssh -p 2222 vagrant@localhost
  ```

- Włączone jest przekazywanie agenta SSH oraz X11.

> [!tip]
> Edytuj plik `~/.ssh/config`, dodając wpis:
> 
> ```ini
> Host dev-station
>    HostName 127.0.0.1
>    Port 2222
>    User vagrant
>    IdentityFile /repo/pl.rachuna-net/tools/vagrant/.vagrant/machines/default/virtualbox/private_key
>    ForwardX11 yes
> ```
>
> Dzięki temu możesz łatwo łączyć się z maszyną wirtualną za pomocą polecenia:
> 
> ```bash
> ssh dev-station
> ```

---
## Dodatkowe informacje

- Maszyna jest uruchamiana w trybie headless (bez GUI).
- Przed uruchomieniem VM można dostosować zmienne środowiskowe, aby zmienić zasoby lub obraz bazowy.
- Ustaw zmienne Vault, jeśli chcesz korzystać z funkcji pobierania certyfikatów.
- Skrypty provisioningowe można modyfikować, edytując plik `scripts_to_run` oraz same skrypty.

### Dodatkowa konfiguracja w Visual Studio Code

Aby ułatwić pracę z maszyną wirtualną w VSCode, zalecane jest zainstalowanie następujących wtyczek:

#### Krok 1. Instalacja pluginów

```bash
ms-vscode-remote.remote-ssh
alefragnani.project-manager
```
#### Krok 2. Dodanie projektu do pluginu Project Manager

Edytuj plik `project.json` (konfiguracja Project Manager) i dodaj:

```json
{
    "name": "pl.rachuna-net/tools/vagrant",
    "rootPath": "vscode-remote://ssh-remote+dev-station/repo/pl.rachuna-net/tools/vagrant",
    "paths": [],
    "tags": []
}
```

#### Wyjaśnienie

- Plugin `Remote - SSH` umożliwia zdalne łączenie się z maszyną wirtualną bezpośrednio z VSCode, co pozwala na wygodną pracę w środowisku VM.
- Plugin `Project Manager` ułatwia zarządzanie projektami i szybkie przełączanie się między nimi.
- Dodanie projektu do Project Manager pozwala na szybkie otwieranie projektu w VSCode zdalnie przez SSH.

Ta konfiguracja znacznie usprawnia pracę z maszyną wirtualną i integrację z VSCode.

---
## Contributions
Jeśli masz pomysły na ulepszenia, zgłoś problemy, rozwidl repozytorium lub utwórz Merge Request. Wszystkie wkłady są mile widziane!
[Contributions](CONTRIBUTING.md)

---
## License
Projekt licencjonowany jest na warunkach [Licencji MIT](LICENSE).

---
# Author Information
### &emsp; Maciej Rachuna
# <img src="https://gitlab.com/pl.rachuna-net/gitlab-profile/-/raw/main/assets/logo/website_logo_transparent_background.png" alt="rachuna-net.pl" height="100"/>

