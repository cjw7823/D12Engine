#include "pch.h"
#include "GeometryGenerator.h"

using namespace DirectX;

MeshData GeometryGenerator::CreateBox(float width, float height, float depth, uint32_t numSubdivisions)
{
    MeshData md;
    Vertex v[24];

    float w2 = 0.5f * width;
    float h2 = 0.5f * height;
    float d2 = 0.5f * depth;
	
    {
		v[0] = Vertex(-w2, -h2, -d2, 0.0f, 0.0f, -1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f);
		v[1] = Vertex(-w2, +h2, -d2, 0.0f, 0.0f, -1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f);
		v[2] = Vertex(+w2, +h2, -d2, 0.0f, 0.0f, -1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f);
		v[3] = Vertex(+w2, -h2, -d2, 0.0f, 0.0f, -1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f);
		v[4] = Vertex(-w2, -h2, +d2, 0.0f, 0.0f, 1.0f, -1.0f, 0.0f, 0.0f, 1.0f, 1.0f);
		v[5] = Vertex(+w2, -h2, +d2, 0.0f, 0.0f, 1.0f, -1.0f, 0.0f, 0.0f, 0.0f, 1.0f);
		v[6] = Vertex(+w2, +h2, +d2, 0.0f, 0.0f, 1.0f, -1.0f, 0.0f, 0.0f, 0.0f, 0.0f);
		v[7] = Vertex(-w2, +h2, +d2, 0.0f, 0.0f, 1.0f, -1.0f, 0.0f, 0.0f, 1.0f, 0.0f);
		v[8] = Vertex(-w2, +h2, -d2, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f);
		v[9] = Vertex(-w2, +h2, +d2, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f);
		v[10] = Vertex(+w2, +h2, +d2, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f);
		v[11] = Vertex(+w2, +h2, -d2, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f);
		v[12] = Vertex(-w2, -h2, -d2, 0.0f, -1.0f, 0.0f, -1.0f, 0.0f, 0.0f, 1.0f, 1.0f);
		v[13] = Vertex(+w2, -h2, -d2, 0.0f, -1.0f, 0.0f, -1.0f, 0.0f, 0.0f, 0.0f, 1.0f);
		v[14] = Vertex(+w2, -h2, +d2, 0.0f, -1.0f, 0.0f, -1.0f, 0.0f, 0.0f, 0.0f, 0.0f);
		v[15] = Vertex(-w2, -h2, +d2, 0.0f, -1.0f, 0.0f, -1.0f, 0.0f, 0.0f, 1.0f, 0.0f);
		v[16] = Vertex(-w2, -h2, +d2, -1.0f, 0.0f, 0.0f, 0.0f, 0.0f, -1.0f, 0.0f, 1.0f);
		v[17] = Vertex(-w2, +h2, +d2, -1.0f, 0.0f, 0.0f, 0.0f, 0.0f, -1.0f, 0.0f, 0.0f);
		v[18] = Vertex(-w2, +h2, -d2, -1.0f, 0.0f, 0.0f, 0.0f, 0.0f, -1.0f, 1.0f, 0.0f);
		v[19] = Vertex(-w2, -h2, -d2, -1.0f, 0.0f, 0.0f, 0.0f, 0.0f, -1.0f, 1.0f, 1.0f);
		v[20] = Vertex(+w2, -h2, -d2, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f);
		v[21] = Vertex(+w2, +h2, -d2, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f);
		v[22] = Vertex(+w2, +h2, +d2, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 0.0f);
		v[23] = Vertex(+w2, -h2, +d2, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f);
    }

	md.Vertices.assign(&v[0], &v[24]);

	uint32_t i[36];

	{
		i[0] = 0; i[1] = 1; i[2] = 2;
		i[3] = 0; i[4] = 2; i[5] = 3;
		i[6] = 4; i[7] = 5; i[8] = 6;
		i[9] = 4; i[10] = 6; i[11] = 7;
		i[12] = 8; i[13] = 9; i[14] = 10;
		i[15] = 8; i[16] = 10; i[17] = 11;
		i[18] = 12; i[19] = 13; i[20] = 14;
		i[21] = 12; i[22] = 14; i[23] = 15;
		i[24] = 16; i[25] = 17; i[26] = 18;
		i[27] = 16; i[28] = 18; i[29] = 19;
		i[30] = 20; i[31] = 21; i[32] = 22;
		i[33] = 20; i[34] = 22; i[35] = 23;
	}

	md.Indices32.assign(&i[0], &i[36]);
	numSubdivisions = std::min<uint32_t>(numSubdivisions, 6u);

	for (uint32_t i = 0; i < numSubdivisions; i++)
		Subdivide(md);

	return md;
}

MeshData GeometryGenerator::CreateSphere(float radius, uint32_t sliceCount, uint32_t stackCount)
{
	MeshData md;

	//­N»óÀ§ ±ØÁ¡¿¡¼­ ½ÃÀÛÇÏ¿© ½ºÅÃÀ» µû¶ó ¾Æ·¡·Î ÀÌµ¿ÇÏ¸é¼­ Á¤Á¡À» °è»ê
	//Á÷»ç°¢Çü ÅØ½ºÃ³¸¦ ±¸¿¡ ¸ÅÇÎÇÒ ¶§ ÅØ½ºÃ³ ¸Ê¿¡¼­ ±ØÁ¡¿¡ ÇÒ´çÇÒ °íÀ¯ÇÑ ÁöÁ¡ÀÌ ¾øÀ¸¹Ç·Î ÅØ½ºÃ³ ÁÂÇ¥ ¿Ö°î ¹ß»ý °¡´É
	Vertex topVertex(0.0f, +radius, 0.0f, 0.0f, +1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f);
	Vertex bottomVertex(0.0f, -radius, 0.0f, 0.0f, -1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f);
	md.Vertices.push_back(topVertex);

	float phiStep = DirectX::XM_PI / stackCount;
	float thetaStep = 2.0f * DirectX::XM_PI / sliceCount;

	//stack ring ¸¶´Ù vertex°è»ê
	for (uint32_t i = 1; i <= stackCount - 1; i++) //top, bottom Á¦¿ÜÇÏ´Ï 1 ~ (stackCount-1)
	{
		float phi = i * phiStep;

		for (uint32_t j = 0; j <= sliceCount; j++)
		{
			float theta = j * thetaStep;
			Vertex v;

			v.Position.x = radius * sinf(phi) * cosf(theta);
			v.Position.y = radius * cosf(phi);
			v.Position.z = radius * sinf(phi) * sinf(theta);

			v.TangentU.x = -radius * sinf(phi) * sinf(theta);
			v.TangentU.y = 0.0f;
			v.TangentU.z = +radius * sinf(phi) * cosf(theta);

			XMVECTOR T = XMLoadFloat3(&v.TangentU);
			XMStoreFloat3(&v.TangentU, XMVector3Normalize(T));
			XMVECTOR P = XMLoadFloat3(&v.Position);
			XMStoreFloat3(&v.Normal, XMVector3Normalize(P)); // Normal »ý¼º

			v.TexC.x = theta / XM_2PI;
			v.TexC.y = phi / XM_PI;

			md.Vertices.push_back(v);
		}
	}
	md.Vertices.push_back(bottomVertex);

	//ÃÖ»ó´Ü ½ºÅÃ ÀÎµ¦½º  °è»ê.
	for (uint32_t i = 1; i <= sliceCount; i++)
	{
		md.Indices32.push_back(0);
		md.Indices32.push_back(i + 1);
		md.Indices32.push_back(i);
	}

	//ÃÖ»óÀ§ ±ØÁ¡ Á¦¿ÜÇÏ°í 1¹øºÎÅÍ ¸µ¸¶´Ù ÀÎµ¦½º °è»ê.
	uint32_t baseIndex = 1;
	//½ÃÀÛ°ú ³¡Á¡Àº °°Àº À§Ä¡Áö¸¸ ´Ù¸¥ Á¤Á¡.
	//ÅØ½ºÃÄ ÁÂÇ¥°¡ ´Ù¸£±â ¶§¹®.
	uint32_t ringVertexCount = sliceCount + 1;
	for (uint32_t i = 0; i < stackCount - 2; i++)
	{
		for (uint32_t j = 0; j < sliceCount; j++)
		{
			md.Indices32.push_back(baseIndex + i * ringVertexCount + j);
			md.Indices32.push_back(baseIndex + i * ringVertexCount + (j + 1));
			md.Indices32.push_back(baseIndex + (i + 1) * ringVertexCount + j);

			md.Indices32.push_back(baseIndex + (i + 1) * ringVertexCount + j);
			md.Indices32.push_back(baseIndex + i * ringVertexCount + (j + 1));
			md.Indices32.push_back(baseIndex + (i + 1) * ringVertexCount + (j + 1));
		}
	}

	//ÃÖÇÏ´Ü ½ºÅÃ ÀÎµ¦½º °è»ê.
	uint32_t southPoleIndex = (uint32_t)md.Vertices.size() - 1;
	baseIndex = southPoleIndex - ringVertexCount;

	for (uint32_t i = 0; i < sliceCount; i++)
	{
		md.Indices32.push_back(southPoleIndex);
		md.Indices32.push_back(baseIndex + i);
		md.Indices32.push_back(baseIndex + i + 1);
	}

	return md;
}

MeshData GeometryGenerator::CreateGeosphere(float radius, uint32_t numSubdivisions)
{
	MeshData md;

	numSubdivisions = std::min<uint32_t>(numSubdivisions, 6u);

	//Á¤ÀÌ½Ê¸éÃ¼¸¦ Å×¼¿·¹ÀÌ¼ÇÇÏ¿© ±¸¸¦ ±Ù»çÀûÀ¸·Î Ç¥Çö.
	const float X = 0.525731f;
	const float Z = 0.850651f;

	//D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST
	XMFLOAT3 pos[12] =
	{
	XMFLOAT3(-X, 0.0f, Z),  XMFLOAT3(X, 0.0f, Z),
	XMFLOAT3(-X, 0.0f, -Z), XMFLOAT3(X, 0.0f, -Z),
	XMFLOAT3(0.0f, Z, X),   XMFLOAT3(0.0f, Z, -X),
	XMFLOAT3(0.0f, -Z, X),  XMFLOAT3(0.0f, -Z, -X),
	XMFLOAT3(Z, X, 0.0f),   XMFLOAT3(-Z, X, 0.0f),
	XMFLOAT3(Z, -X, 0.0f),  XMFLOAT3(-Z, -X, 0.0f)
	};

	uint32_t k[60] =
	{
		1,4,0,  4,9,0,  4,5,9,  8,5,4,  1,8,4,
		1,10,8, 10,3,8, 8,3,5,  3,2,5,  3,7,2,
		3,10,7, 10,6,7, 6,11,7, 6,0,11, 6,1,0,
		10,1,6, 11,0,9, 2,11,9, 5,2,9,  11,2,7
	};

	md.Vertices.resize(12);
	md.Indices32.assign(&k[0], &k[60]);

	for (uint32_t i = 0; i < 12; i++)
		md.Vertices[i].Position = pos[i];

	for (uint32_t i = 0; i < numSubdivisions; i++)
		Subdivide(md);

	for (uint32_t i = 0; i < md.Vertices.size(); i++)
	{
		XMVECTOR n = XMVector3Normalize(XMLoadFloat3(&md.Vertices[i].Position));
		XMVECTOR p = radius * n;

		XMStoreFloat3(&md.Vertices[i].Position, p);
		XMStoreFloat3(&md.Vertices[i].Normal, n);

		float theta = atan2f(md.Vertices[i].Position.z, md.Vertices[i].Position.x);

		//[0, 2pi]
		if (theta < 0.0f) theta += XM_2PI;

		float phi = acosf(md.Vertices[i].Position.y / radius);

		md.Vertices[i].TexC.x = theta / XM_2PI;
		md.Vertices[i].TexC.y = phi / XM_PI;

		md.Vertices[i].TangentU.x = -radius * sinf(phi) * sinf(theta);
		md.Vertices[i].TangentU.y = 0.0f;
		md.Vertices[i].TangentU.z = +radius * sinf(phi) * cosf(theta);

		XMVECTOR T = XMLoadFloat3(&md.Vertices[i].TangentU);
		XMStoreFloat3(&md.Vertices[i].TangentU, XMVector3Normalize(T));
	}

	return md;
}

MeshData GeometryGenerator::CreateCylinder(float bottomRadius, float topRadius, float height, uint32_t sliceCount, uint32_t stackCount)
{
	MeshData md;

	float stackHeight = height / stackCount;
	float radiusStep = (topRadius - bottomRadius) / stackCount;
	uint32_t ringCount = stackCount + 1;

	//¾Æ·¡ºÎÅÍ À§·Î °è»ê.
	for (uint32_t i = 0; i < ringCount; i++)
	{
		float y = -0.5f * height + i * stackHeight;
		float r = bottomRadius + i * radiusStep;

		float dTheta = XM_2PI / sliceCount;
		for (uint32_t j = 0; j <= sliceCount; j++)
		{
			Vertex v;

			float c = cosf(j * dTheta);
			float s = sinf(j * dTheta);

			v.Position = XMFLOAT3(r * c, y, r * s);
			v.TexC.x = (float)j / sliceCount;
			v.TexC.y = 1.0f - (float)i / stackCount;
			/*
				¿ø±âµÕ/¿ø»Ô´ëÀÇ ¿·¸éÀº µÎ ¸Å°³º¯¼ö (t, v)·Î Ç¥ÇöÇÒ ¼ö ÀÖ´Ù.

				t : ¿ø µÑ·¹ ¹æÇâ °¢µµ, 0 ~ 2¥ð
				v : ¼¼·Î ¹æÇâ ºñÀ², 0 ~ 1

				v = 0 : À§ÂÊ ¸µ
				v = 1 : ¾Æ·¡ÂÊ ¸µ

				r0 : ¾Æ·¡ÂÊ ¹ÝÁö¸§ bottom radius
				r1 : À§ÂÊ ¹ÝÁö¸§ top radius
				h  : ³ôÀÌ

				v°¡ Áõ°¡ÇÒ¼ö·Ï À§¿¡¼­ ¾Æ·¡·Î ³»·Á°£´Ù°í Á¤ÀÇÇÑ´Ù.
				ÀÌ·¸°Ô ÇÏ¸é ÅØ½ºÃ³ ÁÂÇ¥ÀÇ V Áõ°¡ ¹æÇâ°ú Ç¥¸éÀÇ ¼¼·Î ¹æÇâÀÌ ÀÏÄ¡ÇÑ´Ù.

				³ôÀÌ¿Í ¹ÝÁö¸§Àº v¿¡ µû¶ó ´ÙÀ½°ú °°ÀÌ º¯ÇÑ´Ù.

					y(v) = h - h * v
					r(v) = r1 + (r0 - r1) * v

				µû¶ó¼­ ¿·¸é À§ÀÇ ÇÑ Á¡Àº ´ÙÀ½°ú °°ÀÌ Ç¥ÇöµÈ´Ù.

					x(t, v) = r(v) * cos(t)
					y(t, v) = h - h * v
					z(t, v) = r(v) * sin(t)

				t ¹æÇâ ¹ÌºÐÀº ¿ø µÑ·¹ ¹æÇâÀÇ Á¢¼±ÀÌ´Ù.
				Áï ÅØ½ºÃ³ U ¹æÇâ°ú ´ëÀÀµÇ´Â TangentUÀÌ´Ù.

					dx/dt = -r(v) * sin(t)
					dy/dt = 0
					dz/dt = +r(v) * cos(t)

				¹æÇâ¸¸ ÇÊ¿äÇÏ¹Ç·Î ½ÇÁ¦ TangentU´Â º¸Åë Á¤±ÔÈ­µÈ ÇüÅÂ¸¦ »ç¿ëÇÑ´Ù.

					TangentU = (-sin(t), 0, cos(t))

				v ¹æÇâ ¹ÌºÐÀº ¼¼·Î ¹æÇâ Á¢¼±ÀÌ´Ù.
				Áï ÅØ½ºÃ³ V ¹æÇâ°ú ´ëÀÀµÇ´Â Bitangent ¹æÇâÀÌ´Ù.

					dx/dv = (r0 - r1) * cos(t)
					dy/dv = -h
					dz/dv = (r0 - r1) * sin(t)

				TangentU¿Í Bitangent¸¦ ÀÌ¿ëÇÏ¸é Ç¥¸é ¹ý¼± NormalÀ» ±¸ÇÒ ¼ö ÀÖ´Ù.

					T = TangentU
					B = Bitangent
					N = normalize(cross(T, B))

				´Ü, cross ¼ø¼­¿¡ µû¶ó ¹ý¼± ¹æÇâÀÌ ¾ÈÂÊ/¹Ù±ùÂÊÀ¸·Î ¹Ù²ð ¼ö ÀÖÀ¸¹Ç·Î
				½ÇÁ¦ ÄÚµå¿¡¼­´Â ¿øÇÏ´Â ¹æÇâÀÌ ³ª¿À´ÂÁö È®ÀÎÇØ¾ß ÇÑ´Ù.
			*/
			v.TangentU = XMFLOAT3(-s, 0.0f, c);

			float dr = bottomRadius - topRadius;
			XMFLOAT3 bitangent(dr * c, -height, dr * s);

			XMVECTOR T = XMLoadFloat3(&v.TangentU);					//ÁÂ¿ì
			XMVECTOR B = XMLoadFloat3(&bitangent);					//»óÇÏ
			XMVECTOR N = XMVector3Normalize(XMVector3Cross(T, B));	//¾ÕµÚ
			XMStoreFloat3(&v.Normal, N);

			md.Vertices.push_back(v);
		}
	}

	//½ÃÀÛ°ú ³¡Á¡Àº °°Àº À§Ä¡Áö¸¸ ´Ù¸¥ Á¤Á¡.
	//ÅØ½ºÃÄ ÁÂÇ¥°¡ ´Ù¸£±â ¶§¹®.
	uint32_t ringVertexCount = sliceCount + 1;

	//ÀÎµ¦½º °è»ê
	for (uint32_t i = 0; i < stackCount; i++)
	{
		for (uint32_t j = 0; j < sliceCount; j++)
		{
			md.Indices32.push_back(i * ringVertexCount + j);
			md.Indices32.push_back((i + 1) * ringVertexCount + j);
			md.Indices32.push_back((i + 1) * ringVertexCount + j + 1);

			md.Indices32.push_back(i * ringVertexCount + j);
			md.Indices32.push_back((i + 1) * ringVertexCount + j + 1);
			md.Indices32.push_back(i * ringVertexCount + j + 1);
		}
	}

	BuildCylinderTopCap(topRadius, height, sliceCount, stackCount, md);
	BuildCylinderBottomCap(bottomRadius, height, sliceCount, stackCount, md);

	return md;
}

MeshData GeometryGenerator::CreateGrid(float width, float depth, uint32_t m, uint32_t n)
{
	MeshData md;

	uint32_t vertexCount = m * n;
	uint32_t faceCount = (m - 1) * (n - 1) * 2;

	float halfWidth = 0.5f * width;
	float halfDepth = 0.5f * depth;

	float dx = width / (n - 1);
	float dz = depth / (m - 1);

	float du = 1.0f / (n - 1);
	float dv = 1.0f / (m - 1);

	md.Vertices.resize(vertexCount);
	for (uint32_t i = 0; i < m; i++)
	{
		float z = halfDepth - i * dz;
		for (uint32_t j = 0; j < n; j++)
		{
			float x = -halfWidth + j * dx;

			md.Vertices[i * n + j].Position = XMFLOAT3(x, 0.0f, z);
			md.Vertices[i * n + j].Normal = XMFLOAT3(0.0f, 1.0f, 0.0f);
			md.Vertices[i * n + j].TangentU = XMFLOAT3(1.0f, 0.0f, 0.0f);

			md.Vertices[i * n + j].TexC.x = j * du;
			md.Vertices[i * n + j].TexC.y = i * dv;
		}
	}

	md.Indices32.resize(faceCount * 3);

	uint32_t k = 0;
	for (uint32_t i = 0; i < m - 1; i++)
	{
		for (uint32_t j = 0; j < n - 1; j++)
		{
			md.Indices32[k] = i * n + j;
			md.Indices32[k + 1] = i * n + j + 1;
			md.Indices32[k + 2] = (i + 1) * n + j;

			md.Indices32[k + 3] = (i + 1) * n + j;
			md.Indices32[k + 4] = i * n + j + 1;
			md.Indices32[k + 5] = (i + 1) * n + j + 1;

			k += 6;
		}
	}

	return md;
}

MeshData GeometryGenerator::CreateQuad(float x, float y, float w, float h, float depth)
{
	MeshData md;

	md.Vertices.resize(4);
	md.Indices32.resize(6);

	md.Vertices[0] = Vertex(
		x, y - h, depth,
		0.0f, 0.0f, -1.0f,
		1.0f, 0.0f, 0.0f,
		0.0f, 1.0f);

	md.Vertices[1] = Vertex(
		x, y, depth,
		0.0f, 0.0f, -1.0f,
		1.0f, 0.0f, 0.0f,
		0.0f, 0.0f);

	md.Vertices[2] = Vertex(
		x + w, y, depth,
		0.0f, 0.0f, -1.0f,
		1.0f, 0.0f, 0.0f,
		1.0f, 0.0f);

	md.Vertices[3] = Vertex(
		x + w, y - h, depth,
		0.0f, 0.0f, -1.0f,
		1.0f, 0.0f, 0.0f,
		1.0f, 1.0f);

	md.Indices32[0] = 0;
	md.Indices32[1] = 1;
	md.Indices32[2] = 2;

	md.Indices32[3] = 0;
	md.Indices32[4] = 2;
	md.Indices32[5] = 3;

	return md;
}

MeshData GeometryGenerator::CreateCircleLine(float radius, uint32_t sliceCount)
{
	MeshData md;

	//sliceCount °¡ ³Ê¹« ÀÛÀ¸¸é ¿øÀÌ ¾Æ´Ï¶ó ¼±,»ï°¢ÇüÃ³·³ º¸ÀÌ¹Ç·Î ÃÖ¼Ò°ª º¸Á¤
	sliceCount = std::max<uint32_t>(3u, sliceCount);

	float dTheta = XM_2PI / sliceCount;

	//line stripÀ¸·Î ´ÝÈù ¿øÀ» ¸¸µé±â À§ÇØ ½ÃÀÛÁ¡°ú ³¡Á¡À» °°Àº À§Ä¡·Î ÇÏ³ª ´õ ³Ö´Â´Ù.
	md.Vertices.reserve(sliceCount + 1);
	md.Indices32.reserve(sliceCount + 1);

	for (uint32_t i = 0; i <= sliceCount; i++)
	{
		float theta = i * dTheta;
		float c = cosf(theta);
		float s = sinf(theta);

		Vertex v;
		v.Position = XMFLOAT3(radius * c, 0.0f, radius * s);
		v.Normal = XMFLOAT3(0.0f, 1.0f, 0.0f);
		v.TangentU = XMFLOAT3(-s, 0.0f, c);

		//¿ø Áß½É ±âÁØÀ¸·Î °£´ÜÇÑ 0~1 ¸ÅÇÎ
		v.TexC.x = 0.5f + 0.5f * c;
		v.TexC.y = 0.5f - 0.5f * s;

		md.Vertices.push_back(v);
		md.Indices32.push_back(i);
	}

	return md;
}

void GeometryGenerator::Subdivide(MeshData& meshData)
{
	MeshData md = meshData;

	meshData.Vertices.resize(0);
	meshData.Indices32.resize(0);

	//       v1
	//       *
	//      / \
	//     /   \
	//  m0*-----*m1
	//   / \   / \
	//  /   \ /   \
	// *-----*-----*
	// v0    m2     v2

	uint32_t numTris = (uint32_t)md.Indices32.size() / 3;
	for (uint32_t i = 0; i < numTris; i++)
	{
		Vertex v0 = md.Vertices[md.Indices32[i * 3 + 0]];
		Vertex v1 = md.Vertices[md.Indices32[i * 3 + 1]];
		Vertex v2 = md.Vertices[md.Indices32[i * 3 + 2]];

		Vertex m0 = MidPoint(v0, v1);
		Vertex m1 = MidPoint(v1, v2);
		Vertex m2 = MidPoint(v0, v2);

		meshData.Vertices.push_back(v0); // 0
		meshData.Vertices.push_back(v1); // 1
		meshData.Vertices.push_back(v2); // 2
		meshData.Vertices.push_back(m0); // 3
		meshData.Vertices.push_back(m1); // 4
		meshData.Vertices.push_back(m2); // 5

		meshData.Indices32.push_back(i * 6 + 0);
		meshData.Indices32.push_back(i * 6 + 3);
		meshData.Indices32.push_back(i * 6 + 5);

		meshData.Indices32.push_back(i * 6 + 3);
		meshData.Indices32.push_back(i * 6 + 4);
		meshData.Indices32.push_back(i * 6 + 5);

		meshData.Indices32.push_back(i * 6 + 5);
		meshData.Indices32.push_back(i * 6 + 4);
		meshData.Indices32.push_back(i * 6 + 2);

		meshData.Indices32.push_back(i * 6 + 3);
		meshData.Indices32.push_back(i * 6 + 1);
		meshData.Indices32.push_back(i * 6 + 4);
	}
}

Vertex GeometryGenerator::MidPoint(const Vertex & v0, const Vertex & v1)
{
	XMVECTOR p0 = XMLoadFloat3(&v0.Position);
	XMVECTOR p1 = XMLoadFloat3(&v1.Position);

	XMVECTOR n0 = XMLoadFloat3(&v0.Normal);
	XMVECTOR n1 = XMLoadFloat3(&v1.Normal);

	XMVECTOR tan0 = XMLoadFloat3(&v0.TangentU);
	XMVECTOR tan1 = XMLoadFloat3(&v1.TangentU);

	XMVECTOR tex0 = XMLoadFloat2(&v0.TexC);
	XMVECTOR tex1 = XMLoadFloat2(&v1.TexC);

	XMVECTOR pos = 0.5 * (p0 + p1);
	XMVECTOR normal = XMVector3Normalize(0.5f * (n0 + n1));
	XMVECTOR tangent = XMVector3Normalize(0.5f * (tan0 + tan1));
	XMVECTOR tex = 0.5f * (tex0 + tex1);

	Vertex v;
	XMStoreFloat3(&v.Position, pos);
	XMStoreFloat3(&v.Normal, normal);
	XMStoreFloat3(&v.TangentU, tangent);
	XMStoreFloat2(&v.TexC, tex);

	return v;
}

void GeometryGenerator::BuildCylinderTopCap(float topRadius, float height, uint32_t sliceCount, uint32_t stackCount, MeshData& meshData)
{
	uint32_t baseIndex = (uint32_t)meshData.Vertices.size();

	float y = 0.5f * height;
	float dTheta = XM_2PI / sliceCount;

	for (uint32_t i = 0; i <= sliceCount; i++)//½ÃÀÛ°ú ³¡Á¡Àº °°Àº À§Ä¡Áö¸¸ ´Ù¸¥ Á¤Á¡.
	{
		float x = topRadius * cosf(i * dTheta);
		float z = topRadius * sinf(i * dTheta);

		// À­¸é Ä¸ÀÇ ÅØ½ºÃ³ ÁÂÇ¥ ¿µ¿ªÀÌ ¹Ø¸é¿¡ ºñ·ÊÇÏµµ·Ï ÇÏ±â À§ÇØ
		// height·Î ³ª´©¾î ½ºÄÉÀÏÀ» ÁÙÀÎ´Ù.
		float u = x / height + 0.5f;
		float v = z / height + 0.5f;

		meshData.Vertices.push_back(Vertex(x, y, z, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 0.0f, u, v));
	}

	meshData.Vertices.push_back(Vertex(0.0f, y, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.5f, 0.5f));

	uint32_t centerIndex = (uint32_t)meshData.Vertices.size() - 1;

	for (uint32_t i = 0; i < sliceCount; i++)
	{
		meshData.Indices32.push_back(centerIndex);
		meshData.Indices32.push_back(baseIndex + i + 1);
		meshData.Indices32.push_back(baseIndex + i);
	}
}

void GeometryGenerator::BuildCylinderBottomCap(float bottomRadius, float height, uint32_t sliceCount, uint32_t stackCount, MeshData & meshData)
{
	uint32_t baseIndex = (uint32_t)meshData.Vertices.size();
	float y = -0.5f * height;

	float dTheta = 2.0f * XM_PI / sliceCount;
	for (uint32_t i = 0; i <= sliceCount; i++)
	{
		float x = bottomRadius * cosf(i * dTheta);
		float z = bottomRadius * sinf(i * dTheta);

		float u = x / height + 0.5f;
		float v = z / height + 0.5f;

		meshData.Vertices.push_back(Vertex(x, y, z, 0.0f, -1.0f, 0.0f, 1.0f, 0.0f, 0.0f, u, v));
	}

	meshData.Vertices.push_back(Vertex(0.0f, y, 0.0f, 0.0f, -1.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.5f, 0.5f));

	uint32_t centerIndex = (uint32_t)meshData.Vertices.size() - 1;

	for (uint32_t i = 0; i < sliceCount; ++i)
	{
		meshData.Indices32.push_back(centerIndex);
		meshData.Indices32.push_back(baseIndex + i);
		meshData.Indices32.push_back(baseIndex + i + 1);
	}
}
