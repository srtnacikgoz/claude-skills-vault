#!/bin/bash
# Smart Firebase Deploy
# Değişen dosyalara göre sadece ilgili fonksiyonları deploy eder
# Kullanım: ./smart-deploy.sh [functions|hosting|all|<fonksiyon-adı>]

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/../../../.." && pwd)/Desktop/InstagramPaylaşımOtomosyonu"
FUNCTIONS_DIR="$PROJECT_ROOT/functions"
ADMIN_DIR="$PROJECT_ROOT/admin"
TIMEOUT="FUNCTIONS_DISCOVERY_TIMEOUT=120000"
NODE_OPTS="NODE_OPTIONS='--max-old-space-size=8192'"

# Renkli çıktı
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()   { echo -e "${RED}[ERROR]${NC} $1"; }

# Controller dosyası → fonksiyon adları mapping
# Her controller'ın export ettiği fonksiyonları çıkar
get_functions_from_controller() {
    local file="$1"
    grep -E "^export const \w+ = functions" "$file" 2>/dev/null | \
        sed -E 's/export const ([a-zA-Z0-9_]+) = functions.*/\1/' | \
        tr '\n' ',' | sed 's/,$//'
}

# Değişen backend dosyalarını tespit et
detect_changed_functions() {
    local base_ref="${1:-HEAD~1}"
    cd "$PROJECT_ROOT"

    # Git diff ile değişen functions/ dosyalarını bul
    local changed_files
    changed_files=$(git diff --name-only "$base_ref" -- functions/src/ 2>/dev/null || \
                    git diff --name-only --cached -- functions/src/ 2>/dev/null || \
                    git status --porcelain functions/src/ | awk '{print $2}')

    if [ -z "$changed_files" ]; then
        echo ""
        return
    fi

    local all_functions=""

    for file in $changed_files; do
        # Controller dosyası değiştiyse → o controller'ın fonksiyonlarını al
        if [[ "$file" == *"controllers/orchestrator/"* && "$file" == *.ts ]]; then
            local full_path="$PROJECT_ROOT/$file"
            if [ -f "$full_path" ]; then
                local fns
                fns=$(get_functions_from_controller "$full_path")
                if [ -n "$fns" ]; then
                    all_functions="${all_functions},${fns}"
                fi
            fi
        fi

        # Service veya type dosyası değiştiyse → tüm controller'ları tara (bağımlılık)
        if [[ "$file" == *"services/"* || "$file" == *"types"* || "$file" == *"orchestrator/types"* ]]; then
            # Hangi controller'lar bu service'i import ediyor?
            local service_name
            service_name=$(basename "$file" .ts)
            local importing_controllers
            importing_controllers=$(grep -rl "$service_name" "$FUNCTIONS_DIR/src/controllers/orchestrator/"*.ts 2>/dev/null || true)

            for ctrl in $importing_controllers; do
                local fns
                fns=$(get_functions_from_controller "$ctrl")
                if [ -n "$fns" ]; then
                    all_functions="${all_functions},${fns}"
                fi
            done
        fi

        # Scheduler değiştiyse
        if [[ "$file" == *"schedulers/"* ]]; then
            local sched_fns
            sched_fns=$(get_functions_from_controller "$PROJECT_ROOT/$file" 2>/dev/null || true)
            if [ -n "$sched_fns" ]; then
                all_functions="${all_functions},${sched_fns}"
            fi
        fi

        # index.ts veya shared dosyaları değiştiyse → tüm fonksiyonlar
        if [[ "$file" == *"index.ts" && "$file" != *"controllers/orchestrator/index.ts" ]]; then
            echo "ALL"
            return
        fi
    done

    # Temizle: baştaki virgül, duplikatlar
    echo "$all_functions" | tr ',' '\n' | sort -u | grep -v '^$' | tr '\n' ',' | sed 's/,$//'
}

# Build
build_functions() {
    info "Functions build ediliyor..."
    cd "$FUNCTIONS_DIR"
    npm run build
    ok "Build başarılı"
}

build_admin() {
    info "Admin panel build ediliyor..."
    cd "$ADMIN_DIR"
    npm run build
    ok "Admin build başarılı"
}

# Deploy functions
deploy_functions() {
    local functions_list="$1"

    cd "$PROJECT_ROOT"

    if [ "$functions_list" = "ALL" ] || [ -z "$functions_list" ]; then
        warn "Tüm fonksiyonlar deploy ediliyor (bu uzun sürebilir)..."
        eval "$TIMEOUT $NODE_OPTS firebase deploy --only functions"
    else
        # functions:fn1,functions:fn2 formatına çevir
        local deploy_target
        deploy_target=$(echo "$functions_list" | tr ',' '\n' | sed 's/^/functions:/' | tr '\n' ',' | sed 's/,$//')

        local fn_count
        fn_count=$(echo "$functions_list" | tr ',' '\n' | wc -l | tr -d ' ')

        info "Deploy ediliyor: $fn_count fonksiyon"
        echo -e "${YELLOW}$deploy_target${NC}"
        eval "$TIMEOUT firebase deploy --only $deploy_target"
    fi

    ok "Functions deploy tamamlandı"
}

# Deploy hosting
deploy_hosting() {
    cd "$PROJECT_ROOT"
    info "Hosting deploy ediliyor..."
    firebase deploy --only hosting
    ok "Hosting deploy tamamlandı"
}

# Ana akış
main() {
    local mode="${1:-smart}"

    echo ""
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}  Firebase Smart Deploy${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo ""

    case "$mode" in
        smart)
            info "Değişiklikler analiz ediliyor..."

            local changed_fns
            changed_fns=$(detect_changed_functions)

            local admin_changed
            admin_changed=$(git diff --name-only HEAD~1 -- admin/src/ 2>/dev/null | head -1)

            if [ -z "$changed_fns" ] && [ -z "$admin_changed" ]; then
                warn "Değişiklik tespit edilemedi. Tüm fonksiyonları deploy etmek için: $0 all"
                exit 0
            fi

            if [ -n "$changed_fns" ]; then
                build_functions
                deploy_functions "$changed_fns"
            fi

            if [ -n "$admin_changed" ]; then
                build_admin
                deploy_hosting
            fi
            ;;

        functions)
            build_functions
            deploy_functions "ALL"
            ;;

        hosting)
            build_admin
            deploy_hosting
            ;;

        all)
            build_functions
            deploy_functions "ALL"
            build_admin
            deploy_hosting
            ;;

        seed)
            local base_url="https://europe-west1-instagram-automation-ad77b.cloudfunctions.net"
            info "Seed endpoint'leri çalıştırılıyor..."

            # Tüm seed endpoint'lerini çalıştır
            for endpoint in seedEnhancementPresets seedEnhancementStyles seedCategories; do
                info "  → $endpoint"
                curl -s -X POST "$base_url/$endpoint" | head -c 200
                echo ""
            done
            ok "Seed tamamlandı"
            ;;

        # Doğrudan fonksiyon adları verilmişse
        *)
            build_functions
            deploy_functions "$mode"
            ;;
    esac

    echo ""
    ok "Deploy işlemi tamamlandı!"
}

main "$@"
