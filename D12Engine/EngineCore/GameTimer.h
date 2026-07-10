#pragma once

#include <chrono>

class GameTimer
{
	using clock = std::chrono::steady_clock;
public:
	GameTimer() { Reset(); };

	double TotalTime() const
	{
		auto endTime = mStopped ? mStopTime : clock::now();
		auto elapsed = endTime - mBaseTime - mPausedDuration;
		return std::chrono::duration<double>(elapsed).count();
	}

	float DeltaTime() const
	{
		return static_cast<float>(mDeltaTime);
	}

	void Reset()
	{
		clock::time_point now = clock::now();

		mBaseTime = now;
		mPrevTime = now;
		mCurrTime = now;
		mStopTime = now;

		mDeltaTime = 0.0;
		mPausedDuration = clock::duration::zero();
		mStopped = false;
	}

	void Start()
	{
		if (mStopped)
		{
			auto now = clock::now();
			mPausedDuration += (now - mStopTime);
			mPrevTime = now;
			mStopTime = now;
			mStopped = false;
		}
	}

	void Stop()
	{
		if (!mStopped)
		{
			mStopTime = clock::now();
			mStopped = true;
		}
	}

	void Tick()
	{
		if (mStopped)
		{
			mDeltaTime = 0.0;
			return;
		}

		mCurrTime = clock::now();
		mDeltaTime = std::chrono::duration<double>(mCurrTime - mPrevTime).count();
		mPrevTime = mCurrTime;

		// steady_clock은 일반적으로 음수 deltaTime이 발생하지 않지만, 예외적인 플랫폼 환경을 고려해 방어적으로 보정한다.
		if(mDeltaTime < 0.0)
			mDeltaTime = 0.0;
	}

private:
	double mDeltaTime;

	clock::time_point mBaseTime;
	clock::time_point mPrevTime;
	clock::time_point mCurrTime;
	clock::time_point mStopTime;
	clock::duration mPausedDuration; //nano second

	bool mStopped;
};