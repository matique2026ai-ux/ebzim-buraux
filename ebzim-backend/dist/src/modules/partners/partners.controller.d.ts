import { PartnersService } from './partners.service';
import { CreatePartnerDto, UpdatePartnerDto } from './dto/create-partner.dto';
export declare class PartnersController {
    private readonly partnersService;
    constructor(partnersService: PartnersService);
    findAll(): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/partner.schema").PartnerDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/partner.schema").Partner & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    getAdminTable(query: any): Promise<{
        data: any[];
        meta: {
            total: number;
            page: number;
            limit: number;
            totalPages: number;
            hasNextPage: boolean;
        };
    }>;
    create(dto: CreatePartnerDto): Promise<import("mongoose").Document<unknown, {}, import("./schemas/partner.schema").PartnerDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/partner.schema").Partner & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    update(id: string, dto: UpdatePartnerDto): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/partner.schema").PartnerDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/partner.schema").Partner & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    delete(id: string): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/partner.schema").PartnerDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/partner.schema").Partner & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
