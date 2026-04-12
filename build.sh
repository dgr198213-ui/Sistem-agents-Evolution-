# ============================================================================
# Build and Test Script
# ============================================================================

#!/bin/bash

echo "🧬 Building Evolutionary Agents Framework"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Nim is installed
if ! command -v nim &> /dev/null; then
    echo -e "${RED}❌ Nim is not installed${NC}"
    echo "Please install Nim from https://nim-lang.org/"
    exit 1
fi

echo -e "${GREEN}✓ Nim version: $(nim --version | head -n 1)${NC}"
echo ""

# Create build directory
mkdir -p build

echo "📦 Building modules..."
echo ""

# Build all example programs
EXAMPLES=(
    "example_foraging"
    "example_coevolution"
    "example_swarm"
)

SUCCESS_COUNT=0
FAIL_COUNT=0

for example in "${EXAMPLES[@]}"; do
    echo -e "${YELLOW}Building $example...${NC}"
    if nim c --out:build/$example $example.nim 2>&1 | grep -q "Error"; then
        echo -e "${RED}❌ Failed to build $example${NC}"
        ((FAIL_COUNT++))
    else
        echo -e "${GREEN}✓ Successfully built $example${NC}"
        ((SUCCESS_COUNT++))
    fi
    echo ""
done

echo "=========================================="
echo -e "Build Summary:"
echo -e "  ${GREEN}Success: $SUCCESS_COUNT${NC}"
echo -e "  ${RED}Failed: $FAIL_COUNT${NC}"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}🎉 All builds successful!${NC}"
    echo ""
    echo "Run examples with:"
    echo "  ./build/example_foraging"
    echo "  ./build/example_coevolution"
    echo "  ./build/example_swarm"
    exit 0
else
    echo -e "${RED}⚠️  Some builds failed${NC}"
    exit 1
fi
