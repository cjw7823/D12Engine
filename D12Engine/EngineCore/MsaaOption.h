#pragma once

//#include <Windows.h>
#include <vector>
#include <array>

struct MsaaOption
{
	MsaaOption() = default;
	MsaaOption(uint16_t i) { index = i; }

	static constexpr std::array<uint16_t, 4> kMsaaSampleCandidates = { 2, 4, 8, 16 };
	inline static std::vector<std::pair<uint16_t, uint16_t>> UsableSamples{ {1,1} }; //sample count, num quality levels

	bool IsEnable() { return index == 0 ? false : true; }

	void operator()(uint16_t i)
	{
		if (i < kMsaaSampleCandidates[0] || i > kMsaaSampleCandidates.back())
		{
			index = 0;
			return;
		}

		for (uint16_t j = 0; j < UsableSamples.size(); j++)
		{
			uint16_t k = UsableSamples[j].first;
			if (i == k) index = i;
			else if (i < k) index = j - 1;
		}
	}

	uint16_t GetState() const { return index; }
	uint16_t SampleCount() const { return UsableSamples[index].first; }
	uint16_t Quality() const { return UsableSamples[index].second - 1; }
	void Next()
	{
		index++;
		if (index >= UsableSamples.size()) index = 0;
	}

private:
	uint16_t index = 0;
};
