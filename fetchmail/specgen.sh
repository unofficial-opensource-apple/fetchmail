#!/bin/sh

# WARNING:
# WARNING: If you change the description, also change genlsm.sh.in!
# WARNING:
version="$1"

set -e

if [ -z "$version" ] ; then
    echo >&2 "Usage: $0 <version>"
    exit 1
fi

email="fetchmail-devel@lists.berlios.de"
packager="Fetchmail Developers <$email>"
rpmver=`echo "$version" | sed 's/-/./g'`
if test $rpmver = $version ; then
    vervar="%{version}"
    setupargs=
else
    vervar="${version}"
    setupargs="-n %{name}-${vervar}"
fi

LANG=C
LC_TIME=C
export LANG LC_TIME

cat <<EOF
# Note: Do not hack fetchmail.spec by hand -- it's generated by specgen.sh

# Set to 0 if you do not have python
%define have_python 1

Name:		fetchmail
Version:	$rpmver
Release:	1
Vendor:		The Community Fetchmail Project
Packager:	$packager
URL:		http://developer.berlios.de/projects/fetchmail
Source:		%{name}-${vervar}.tar.bz2
Group:		Applications/Mail
Group(pt_BR):	Aplicações/Correio Eletrônico
Group(vi):	Ứng dụng/Thư
License:	GPL
Icon:		fetchmail.xpm
%if "%{_vendor}" == "suse"
Requires:	smtp_daemon
%else
Requires:	smtpdaemon
%endif
BuildPrereq:	gettext-devel openssl-devel
BuildRoot:	/var/tmp/%{name}-%{version}
Summary:	Full-featured POP/IMAP mail retrieval daemon
Summary(da):	Alsidig POP/IMAP post-afhentnings dæmon
Summary(de):	Program zum Abholen von E-Mail via POP/IMAP
Summary(es):	Recolector de correo via POP/IMAP
Summary(fr):	Daemon de récupération de courrier électronique POP/IMAP complet
Summary(pl):	Zdalny demon pocztowy do protokołów POP2, POP3, APOP, IMAP
Summary(pt):	Busca mensagens de um servidor usando POP ou IMAP
Summary(tr):	POP2, POP3, APOP, IMAP protokolleri ile uzaktan mektup alma yazılımı
Summary(vi):	trình nền lấy thư POP/IMAP có tính năng đầy đủ
BuildRoot: %{_tmppath}/%{name}-root
#Keywords: mail, client, POP, POP2, POP3, APOP, RPOP, KPOP, IMAP, ETRN, ODMR, SMTP, ESMTP, GSSAPI, RPA, NTLM, CRAM-MD5, SASL
#Destinations:	fetchmail-users@lists.berlios.de, fetchmail-announce@lists.berlios.de

%description
Fetchmail is a free, full-featured, robust, and well-documented remote
mail retrieval and forwarding utility intended to be used over
on-demand TCP/IP links (such as SLIP or PPP connections).  It
retrieves mail from remote mail servers and forwards it to your local
(client) machine's delivery system, so it can then be be read by
normal mail user agents such as mutt, elm, pine, (x)emacs/gnus, or mailx.
Comes with an interactive GUI configurator suitable for end-users.

%description -l vi
Fetchmail là tiện ích miễn phí có khả năng lấy và chuyển tiếp thư từ xa,
có tính năng đầy đủ, rất mạnh và có nhiều tài liệu hướng dẫn. Nó đã được
nhằm sử dụng qua liên kết TCP/IP khi-yeu-cầu (như sự kết nỗi SLIP hay
PPP). Fetchmail lấy thư từ máy phục vụ thư ở xa và chuyển tiếp tới hệ
thống phát thư của máy (khách) cục bộ, để cung cấp thư sẽ được đọc bởi
tác nhân thư chuẩn như mutt, elm, pine, (x)emacs/gnus, hay mailx.
Fetchmail có sẵn một bộ cấu hình giao diện người dùng đồ họa, thích hợp
với người dùng cuối cùng.

%description -l fr
Fetchmail est un outil de récupération et de transfert de courrier
électronique. Il est libre, complet, robuste et bien documenté. Il est
utilisé à travers des liens TCP/IP établis à la demande (telles que des
connexions SLIP ou PPP). Il récupère le courrier électronique sur des
serveurs distants et le transfère sur la machine locale (client). Le
courrier électronique peut alors être lu à l'aide de clients
standard, comme mutt, elm, pine, (x)emacs/gnus ou mailx. L'interface de
configuration est adaptée à tout utilisateur.

%description -l de
Fetchmail ist ein freies, vollständiges, robustes und
wohldokumentiertes Werkzeug zum Abholen und Weiterleiten von E-Mail,
zur Verwendung über temporäre TCP/IP-Verbindungen (wie
z.B. SLIP- oder PPP-Verbindungen).  Es holt E-Mail von
entfernten Mail-Servern ab und reicht sie an das Auslieferungssystem
der lokalen Client-Maschine weiter, damit sie dann von normalen MUAs
("mail user agents") wie mutt, elm, pine, (x)emacs/gnus oder mailx
gelesen werden können.  Ein interaktiver GUI-Konfigurator für
Endbenutzer wird mitgeliefert.

%description -l pt
Fetchmail é um programa que é usado para recuperar mensagens de um
servidor de mail remoto. Ele pode usar Post Office Protocol (POP)
ou IMAP (Internet Mail Access Protocol) para isso, e entrega o mail
através do servidor local SMTP (normalmente sendmail).
Vem com uma interface gráfica para sua configuração.

%description -l es
Fetchmail es una utilidad gratis, completa, robusta y bien documentada
para la recepción y reenvío de correo pensada para ser usada en
conexiones TCP/IP temporales (como SLIP y PPP). Recibe el correo de
servidores remotos y lo reenvía al sistema de entrega local, siendo de
ese modo posible leerlo con programas como mutt, elm, pine, (x)emacs/gnus
o mailx. Contiene un configurador GUI interactivo pensado para usuarios.

%description -l pl
Fetchmail jest programem do ściągania poczty ze zdalnych serwerów
pocztowych. Do ściągania poczty może on uzywać protokołów POP (Post Office
Protocol) lub IMAP (Internet Mail Access Protocol). Ściągniętą pocztę
dostarcza do końcowych odbiorców poprzez lokalny serwer SMTP.

%description -l tr
fetchmail yazılımı, POP veya IMAP desteği veren bir sunucuda yer alan
mektuplarınızı alır.

%description -l da
Fetchmail er et gratis, robust, alsidigt og vel-dokumenteret værktøj
til afhentning og videresending af elektronisk post via TCP/IP
baserede opkalds-forbindelser (såsom SLIP eller PPP forbindelser).
Den henter post fra en ekstern post-server, og videresender den
til din lokale klient-maskines post-system, så den kan læses af
almindelige mail klienter såsom mutt, elm, pine, (x)emacs/gnus,
eller mailx. Der medfølger også et interaktivt GUI-baseret
konfigurations-program, som kan bruges af almindelige brugere.

%if %{have_python}
%package -n fetchmailconf
Summary:	A GUI configurator for generating fetchmail configuration files
Summary(de):	GUI-Konfigurator für fetchmail
Summary(pl):	GUI konfigurator do fetchmaila
Summary(fr):	Une interface de configuration qui permet de créer les fichiers de configuration de fetchmail
Summary(es):	Configurador GUI interactivo para fetchmail
Summary(pt):	Um configurador gráfico para o fetchmail
Summary(vi):	bộ cấu hình giao diện người dùng đồ họa để tạo ra tập tin cấu hình fetchmail
Group:		Utilities/System
Group(pt):	Utilitários/Sistema
Group(vi):	Tiện ích/Hệ thống
BuildPrereq:	python
Requires:	%{name} = %{version}, python

%description -n fetchmailconf
A GUI configurator for generating fetchmail configuration file written in
Python.

%description -n fetchmailconf -l vi
Một bộ cấu hình giao diện người dùng đồ họa để tạo ra tập tin cấu hình
fetchmail, được ghi bằng Python.

%description -n fetchmailconf -l de
Ein in Python geschriebenes Programm mit graphischer Oberfläche zur
Erzeugung von Fetchmail-Konfigurationsdateien.

%description -n fetchmailconf -l pt
Um configurador gráfico para a geração de arquivos de configuração do
fetchmail. Feito em python.

%description -n fetchmailconf -l es
Configurador gráfico para fetchmail escrito en python.

%description -n fetchmailconf -l de
Ein interaktiver GUI-Konfigurator für fetchmail in Python.

%description -n fetchmailconf -l pl
GUI konfigurator do fetchmaila napisany w pythonie.

%description -n fetchmailconf -l fr
Une interface graphique de configuration pour créer les fichiers de
configuration de fetchmail écrite en python.

%endif

%{?debug_package}

%prep
%setup -q $setupargs

%build
%configure --without-included-gettext --without-kerberos --with-ssl
make

%install
rm -rf \$RPM_BUILD_ROOT
make install DESTDIR=\$RPM_BUILD_ROOT

%if %{have_python}
mkdir -p \$RPM_BUILD_ROOT/usr/lib/rhs/control-panel
cp rh-config/*.{xpm,init} \$RPM_BUILD_ROOT/usr/lib/rhs/control-panel
mkdir -p \$RPM_BUILD_ROOT/etc/X11/wmconfig
cp rh-config/fetchmailconf.wmconfig \$RPM_BUILD_ROOT/etc/X11/wmconfig/fetchmailconf
%endif

chmod 644 contrib/*

%clean
rm -rf \$RPM_BUILD_ROOT %{_builddir}/%name-%version

%files
%defattr (644, root, root, 755)
%doc ABOUT-NLS FAQ COPYING FEATURES NEWS
%doc NOTES OLDNEWS README README.SSL README.SSL-SERVER
%doc contrib
%doc fetchmail-features.html fetchmail-FAQ.html esrs-design-notes.html
%doc design-notes.html
%doc fetchmail-FAQ.pdf
%attr(644, root, man) %{_mandir}/man1/fetchmail.1*
%attr(755, root, root) %{_bindir}/fetchmail
%attr(644,root,root) %{_datadir}/locale/*/LC_MESSAGES/fetchmail.mo

%if %{have_python}
%files -n fetchmailconf
%defattr (644, root, root, 755)
%attr(644,root,root) /etc/X11/wmconfig/fetchmailconf
%attr(755,root,root) %{_bindir}/fetchmailconf
%attr(644, root, man) %{_mandir}/man1/fetchmailconf.1*
%attr(755,root,root) %{py_libdir}/site-packages/fetchmailconf.py*
/usr/lib/rhs/control-panel/fetchmailconf.xpm
/usr/lib/rhs/control-panel/fetchmailconf.init
%endif

%changelog
* `date '+%a %b %d %Y'` <$email> ${rpmver}
- See the project NEWS file for recent changes.
EOF
