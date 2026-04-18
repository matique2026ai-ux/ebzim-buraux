import { Model } from 'mongoose';
import { PartnerDocument } from './schemas/partner.schema';
import { CreatePartnerDto, UpdatePartnerDto } from './dto/create-partner.dto';
export declare class PartnersService {
    private partnerModel;
    constructor(partnerModel: Model<PartnerDocument>);
    findAll(): Promise<(import("mongoose").Document<unknown, {}, PartnerDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/partner.schema").Partner & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    getAdminTable(options: any): Promise<{
        data: any[];
        meta: {
            total: number;
            page: number;
            limit: number;
            totalPages: number;
            hasNextPage: boolean;
        };
    }>;
    create(dto: CreatePartnerDto): Promise<import("mongoose").Document<unknown, {}, PartnerDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/partner.schema").Partner & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    update(id: string, dto: UpdatePartnerDto): Promise<(import("mongoose").Document<unknown, {}, PartnerDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/partner.schema").Partner & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    delete(id: string): Promise<(import("mongoose").Document<unknown, {}, PartnerDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/partner.schema").Partner & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
