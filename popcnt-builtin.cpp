
template<typename T>
static inline std::uint64_t popcnt_builtin(const uint8_t* data, const size_t n)
{
    uint64_t result = 0,
             i = 0;

    for (; i < n; i += sizeof(T)) {
        T v = *reinterpret_cast<const T*>(data + i);
        if (sizeof(T) == 4)
            result += __builtin_popcount(v);
        else
            result += __builtin_popcountll(v);
    }

    for (; i < n; i++)
        result += lookup8bit[data[i]];

    return result;
}

std::uint64_t popcnt_builtin_64bit(const uint8_t* data, const size_t n)
{
    return popcnt_builtin<uint64_t>(data, n);
}

std::uint64_t popcnt_builtin_32bit(const uint8_t* data, const size_t n)
{
    return popcnt_builtin<uint32_t>(data, n);
}
