#include <cassert>

#include <deep_ep/common/gin_resource_alloc.cuh>

int main() {
    using namespace deep_ep::elastic::gin_alloc;

    assert(max_gin_context_cnt(1, false) == 17);
    assert(max_gin_context_cnt(2, false) == 17);
    assert(max_gin_context_cnt(8, false) == 17);
    assert(max_gin_context_cnt(16, false) == 15);

    assert(max_gin_context_cnt(1, true) == 41);
    assert(max_gin_context_cnt(2, true) == 41);
    assert(max_gin_context_cnt(8, true) == 28);
    assert(max_gin_context_cnt(16, true) == 15);
    return 0;
}
